import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/farm_view_model.dart';
import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/milk_view_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../viewmodels/activities_view_model.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class FilterState extends ChangeNotifier {
  DateTimeRange? dateRange;
  String status; // 'Active', 'All', 'Sold', 'Dead', 'Archived'
  FilterState({this.dateRange, this.status = 'Active'});

  void setDateRange(DateTimeRange? range) {
    dateRange = range;
    notifyListeners();
  }

  void setStatus(String s) {
    status = s;
    notifyListeners();
  }
}

class CattleReportScreen extends StatefulWidget {
  const CattleReportScreen({super.key});

  @override
  State<CattleReportScreen> createState() => _CattleReportScreenState();
}

class _CattleReportScreenState extends State<CattleReportScreen> {
  @override
  void initState() {
    super.initState();
    // Delay to ensure context is available
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final width = MediaQuery.of(context).size.width;
    //   if (width < 600) {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeLeft,
    //       DeviceOrientation.landscapeRight,
    //     ]);
    //   }
    // });
  }

  @override
  void dispose() {
    // Reset to portrait only when leaving this page
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFarm = context.watch<CurrentFarm>();
    final farmId = currentFarm.farm!.id;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CattleViewModel>(
          create: (_) => CattleViewModel()..getByFarmId(farmId),
        ),
        ChangeNotifierProvider<MilkViewModel>(
          create: (_) => MilkViewModel()..getByFarmId(farmId),
        ),
        ChangeNotifierProvider<FilterState>(create: (_) => FilterState()),
        ChangeNotifierProvider<ActivitiesViewModel>(
          create: (_) => ActivitiesViewModel()..getByFarmId(farmId),
        ),
      ],
      child: _CattleReportBody(
        farmName: currentFarm.farm!.name,
        farmId: farmId,
      ),
    );
  }
}

class _CattleReportBody extends StatelessWidget {
  final String farmName;
  final String farmId;
  const _CattleReportBody({required this.farmName, required this.farmId});

  static final _populationChartKey = GlobalKey();
  static final _milkTrendChartKey = GlobalKey();
  static final _breedChartKey = GlobalKey();
  static final _ageChartKey = GlobalKey();
  static final _topProducersChartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cattle Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () => _exportReportAsPdf(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReportHeader(farmName: farmName),
              const SizedBox(height: 16),
              Consumer2<CattleViewModel, MilkViewModel>(
                builder: (context, cattleVM, milkVM, _) {
                  final isLoading = cattleVM.isLoading;
                  final cattleList = cattleVM.cattleList;
                  final milkList = milkVM.milkList;
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cattleList.isEmpty || milkList.isEmpty) {
                    return const Center(child: Text('No data available.'));
                  }
                  // Filter state
                  final filter = context.watch<FilterState>();
                  final range =
                      filter.dateRange ??
                      DateTimeRange(
                        start: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          1,
                        ),
                        end: DateTime.now(),
                      );
                  final filteredMilk = milkList.where((m) {
                    final d = DateTime.parse(m.date);
                    return !d.isBefore(range.start) && !d.isAfter(range.end);
                  }).toList();
                  final filteredCattle = filter.status == 'All'
                      ? cattleList
                      : cattleList
                            .where(
                              (c) =>
                                  c.status.toLowerCase() ==
                                  filter.status.toLowerCase(),
                            )
                            .toList();
                  // Today's date
                  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  // Milk today
                  final milkToday = filteredMilk
                      .where((m) => m.date == today)
                      .fold<double>(0, (sum, m) => sum + (m.total ?? 0));
                  // Average yield (this month)
                  final now = DateTime.now();
                  final monthStart = DateTime(now.year, now.month, 1);
                  final monthStartStr = DateFormat(
                    'yyyy-MM-dd',
                  ).format(monthStart);
                  final milkThisMonth = filteredMilk
                      .where(
                        (m) =>
                            m.date.compareTo(monthStartStr) >= 0 &&
                            m.date.compareTo(today) <= 0,
                      )
                      .toList();
                  final totalMilkThisMonth = milkThisMonth.fold<double>(
                    0,
                    (sum, m) => sum + (m.total ?? 0),
                  );
                  final avgYield = filteredCattle.isNotEmpty
                      ? (totalMilkThisMonth / filteredCattle.length)
                            .toStringAsFixed(1)
                      : '--';
                  // Top producer (this month)
                  final Map<String, double> cowYield = {};
                  for (final m in milkThisMonth) {
                    if (m.cowName != null) {
                      cowYield[m.cowName!] =
                          (cowYield[m.cowName!] ?? 0) + (m.total ?? 0);
                    }
                  }
                  String topProducer = '--';
                  double topYield = 0;
                  cowYield.forEach((name, yield) {
                    if (yield > topYield) {
                      topProducer = name;
                      topYield = yield;
                    }
                  });
                  return _KpiSummaryRow(
                    totalCattle: filteredCattle.length.toString(),
                    milkToday: milkToday.toStringAsFixed(1),
                    avgYield: avgYield,
                    topProducer: topProducer,
                  );
                },
              ),
              const SizedBox(height: 24),
              RepaintBoundary(
                key: _CattleReportBody._populationChartKey,
                child: _PopulationBreakdownChart(),
              ),
              const SizedBox(height: 16),
              RepaintBoundary(
                key: _CattleReportBody._milkTrendChartKey,
                child: _MilkProductionTrendChart(),
              ),
              const SizedBox(height: 16),
              RepaintBoundary(
                key: _CattleReportBody._breedChartKey,
                child: _BreedDistributionChart(),
              ),
              const SizedBox(height: 16),
              RepaintBoundary(
                key: _CattleReportBody._ageChartKey,
                child: _AgeDistributionChart(),
              ),
              const SizedBox(height: 16),
              RepaintBoundary(
                key: _CattleReportBody._topProducersChartKey,
                child: _TopProducersChart(),
              ),
              const SizedBox(height: 16),
              _RecentActivitiesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String farmName;
  const _ReportHeader({required this.farmName});

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterState>();
    final dateLabel = filter.dateRange == null
        ? 'This Month'
        : '${DateFormat('d MMM').format(filter.dateRange!.start)} - ${DateFormat('d MMM').format(filter.dateRange!.end)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          farmName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final now = DateTime.now();
                  final initialDateRange =
                      filter.dateRange ??
                      DateTimeRange(
                        start: DateTime(now.year, now.month, 1),
                        end: now,
                      );
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year - 10),
                    lastDate: DateTime(now.year + 1),
                    initialDateRange: initialDateRange,
                  );
                  if (picked != null) {
                    filter.setDateRange(picked);
                  }
                });
              },
              icon: const Icon(Icons.date_range),
              label: Text(dateLabel),
            ),
            const SizedBox(width: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final status in [
                      'Active',
                      'All',
                      'Sold',
                      'Dead',
                      'Archived',
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FilterChip(
                          label: Text(status),
                          selected: filter.status == status,
                          onSelected: (_) => filter.setStatus(status),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiSummaryRow extends StatelessWidget {
  final String totalCattle;
  final String milkToday;
  final String avgYield;
  final String topProducer;
  const _KpiSummaryRow({
    this.totalCattle = '--',
    this.milkToday = '--',
    this.avgYield = '--',
    this.topProducer = '--',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _KpiCard(title: 'Total Cattle', value: totalCattle),
                  _KpiCard(title: 'Milk Today', value: milkToday),
                  _KpiCard(title: 'Avg Yield', value: avgYield),
                  _KpiCard(title: 'Top Producer', value: topProducer),
                ],
              )
            : Column(
                children: [
                  _KpiCard(title: 'Total Cattle', value: totalCattle),
                  const SizedBox(height: 8),
                  _KpiCard(title: 'Milk Today', value: milkToday),
                  const SizedBox(height: 8),
                  _KpiCard(title: 'Avg Yield', value: avgYield),
                  const SizedBox(height: 8),
                  _KpiCard(title: 'Top Producer', value: topProducer),
                ],
              );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  const _KpiCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ChartSectionPlaceholder extends StatelessWidget {
  final String title;
  const _ChartSectionPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 180,
        child: Center(
          child: Text(
            '$title (Chart Placeholder)',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _PopulationBreakdownChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CattleViewModel>(
      builder: (context, cattleVM, _) {
        final cattleList = cattleVM.cattleList;
        if (cattleList.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Population Breakdown');
        }
        // Count by status
        final statusCounts = <String, int>{};
        for (final c in cattleList) {
          final status = c.status ?? 'Unknown';
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
        }
        final data = statusCounts.entries
            .map((e) => _StatusCount(e.key, e.value))
            .toList();
        final colorScheme = Theme.of(context).colorScheme;
        final statusColors = {
          'active': colorScheme.primary,
          'sold': colorScheme.secondary,
          'dead': colorScheme.error,
          'archived': colorScheme.outline,
          'Unknown': colorScheme.surfaceContainerHighest,
        };
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Population Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 220,
                  child: SfCircularChart(
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                    ),
                    series: <PieSeries<_StatusCount, String>>[
                      PieSeries<_StatusCount, String>(
                        dataSource: data,
                        xValueMapper: (_StatusCount d, _) => d.status,
                        yValueMapper: (_StatusCount d, _) => d.count,
                        dataLabelMapper: (_StatusCount d, _) =>
                            d.count.toString(),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        pointColorMapper: (_StatusCount d, _) =>
                            statusColors[d.status.toLowerCase()] ??
                            colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MilkProductionTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MilkViewModel>(
      builder: (context, milkVM, _) {
        final milkList = milkVM.milkList;
        if (milkList.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Milk Production Trend');
        }
        // Get current month range
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final today = DateTime(now.year, now.month, now.day);
        final dateFormat = DateFormat('yyyy-MM-dd');
        // Group by date
        final Map<String, double> dailyTotals = {};
        for (final m in milkList) {
          final date = m.date;
          final dateObj = dateFormat.parse(date);
          if (dateObj.isBefore(monthStart) || dateObj.isAfter(today)) continue;
          dailyTotals[date] = (dailyTotals[date] ?? 0) + (m.total ?? 0);
        }
        // Fill missing days with 0
        final List<_MilkTrendPoint> data = [];
        for (int i = 0; i <= today.difference(monthStart).inDays; i++) {
          final d = monthStart.add(Duration(days: i));
          final dStr = dateFormat.format(d);
          data.add(_MilkTrendPoint(d, dailyTotals[dStr] ?? 0));
        }
        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Milk Production Trend (This Month)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 220,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat('d MMM'),
                      intervalType: DateTimeIntervalType.days,
                      majorGridLines: const MajorGridLines(width: 0.5),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Liters'),
                      majorGridLines: const MajorGridLines(width: 0.5),
                    ),
                    series: <CartesianSeries<dynamic, dynamic>>[
                      AreaSeries<_MilkTrendPoint, DateTime>(
                        dataSource: data,
                        xValueMapper: (_MilkTrendPoint d, _) => d.date,
                        yValueMapper: (_MilkTrendPoint d, _) => d.total,
                        color: colorScheme.primary.withOpacity(0.5),
                        borderColor: colorScheme.primary,
                        borderWidth: 2,
                        name: 'Milk',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: false,
                        ),
                        markerSettings: const MarkerSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MilkTrendPoint {
  final DateTime date;
  final double total;
  _MilkTrendPoint(this.date, this.total);
}

class _StatusCount {
  final String status;
  final int count;
  _StatusCount(this.status, this.count);
}

class _BreedDistributionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CattleViewModel>(
      builder: (context, cattleVM, _) {
        final cattleList = cattleVM.cattleList;
        if (cattleList.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Breed Distribution');
        }
        // Count by breed
        final breedCounts = <String, int>{};
        for (final c in cattleList) {
          final breed = c.breed.isNotEmpty ? c.breed : 'Unknown';
          breedCounts[breed] = (breedCounts[breed] ?? 0) + 1;
        }
        final data = breedCounts.entries
            .map((e) => _BreedCount(e.key, e.value))
            .toList();
        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breed Distribution',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 220,
                  child: SfCircularChart(
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                    ),
                    series: <PieSeries<_BreedCount, String>>[
                      PieSeries<_BreedCount, String>(
                        dataSource: data,
                        xValueMapper: (_BreedCount d, _) => d.breed,
                        yValueMapper: (_BreedCount d, _) => d.count,
                        dataLabelMapper: (_BreedCount d, _) =>
                            d.count.toString(),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        pointColorMapper: (_BreedCount d, idx) =>
                            colorScheme.primary.withOpacity(0.7 - (idx * 0.1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BreedCount {
  final String breed;
  final int count;
  _BreedCount(this.breed, this.count);
}

class _AgeDistributionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CattleViewModel>(
      builder: (context, cattleVM, _) {
        final cattleList = cattleVM.cattleList;
        if (cattleList.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Age Distribution');
        }
        // Age group definitions (example: adjust as needed)
        final now = DateTime.now();
        final ageGroups = <String, int>{
          'Calves (<1y)': 0,
          'Heifers (1-2y)': 0,
          'Cows (2-8y)': 0,
          'Old (>8y)': 0,
        };
        for (final c in cattleList) {
          try {
            final dob = DateTime.parse(c.dob);
            final age = now.difference(dob).inDays ~/ 365;
            if (age < 1) {
              ageGroups['Calves (<1y)'] = ageGroups['Calves (<1y)']! + 1;
            } else if (age < 2) {
              ageGroups['Heifers (1-2y)'] = ageGroups['Heifers (1-2y)']! + 1;
            } else if (age <= 8) {
              ageGroups['Cows (2-8y)'] = ageGroups['Cows (2-8y)']! + 1;
            } else {
              ageGroups['Old (>8y)'] = ageGroups['Old (>8y)']! + 1;
            }
          } catch (_) {
            // skip invalid dates
          }
        }
        final data = ageGroups.entries
            .map((e) => _AgeGroupCount(e.key, e.value))
            .toList();
        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Age Distribution',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 220,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Count'),
                      majorGridLines: const MajorGridLines(width: 0.5),
                    ),
                    series: <CartesianSeries<_AgeGroupCount, String>>[
                      ColumnSeries<_AgeGroupCount, String>(
                        dataSource: data,
                        xValueMapper: (_AgeGroupCount d, _) => d.group,
                        yValueMapper: (_AgeGroupCount d, _) => d.count,
                        pointColorMapper: (_, idx) =>
                            colorScheme.primary.withOpacity(0.7 - (idx * 0.1)),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AgeGroupCount {
  final String group;
  final int count;
  _AgeGroupCount(this.group, this.count);
}

class _TopProducersChart extends StatelessWidget {
  const _TopProducersChart();

  @override
  Widget build(BuildContext context) {
    return Consumer<MilkViewModel>(
      builder: (context, milkVM, _) {
        final milkList = milkVM.milkList;
        if (milkList.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Top Producers');
        }
        // Get current month range
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final today = DateTime(now.year, now.month, now.day);
        final dateFormat = DateFormat('yyyy-MM-dd');
        // Sum milk per cow for this month
        final Map<String, double> cowYield = {};
        for (final m in milkList) {
          final dateObj = dateFormat.parse(m.date);
          if (dateObj.isBefore(monthStart) || dateObj.isAfter(today)) continue;
          if (m.cowName != null && m.cowName!.isNotEmpty) {
            cowYield[m.cowName!] = (cowYield[m.cowName!] ?? 0) + (m.total ?? 0);
          }
        }
        if (cowYield.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Top Producers');
        }
        // Sort and take top N
        final sorted = cowYield.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final data = sorted
            .take(5) // Changed from topN to 5
            .map((e) => _ProducerYield(e.key, e.value))
            .toList();
        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Producers (This Month)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 220,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Liters'),
                      majorGridLines: const MajorGridLines(width: 0.5),
                    ),
                    series: <BarSeries<_ProducerYield, String>>[
                      BarSeries<_ProducerYield, String>(
                        dataSource: data,
                        xValueMapper: (_ProducerYield d, _) => d.cow,
                        yValueMapper: (_ProducerYield d, _) => d.yield,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        pointColorMapper: (_, idx) =>
                            colorScheme.primary.withOpacity(0.7 - (idx * 0.1)),
                        isTrackVisible: true,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProducerYield {
  final String cow;
  final double yield;
  _ProducerYield(this.cow, this.yield);
}

class _RecentActivitiesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final farmId = context.read<CurrentFarm>().farm?.id;
    if (farmId == null) {
      return const _ChartSectionPlaceholder(title: 'Recent Activities');
    }
    return Consumer<ActivitiesViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final activities = vm.activityList;
        if (activities.isEmpty) {
          return const _ChartSectionPlaceholder(title: 'Recent Activities');
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activities',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length > 8 ? 8 : activities.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final a = activities[idx];
                    return ListTile(
                      leading: Icon(
                        Icons.event_note,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(a.type ?? 'Activity'),
                      subtitle: Text('${a.date} • ${a.cattleName ?? ''}'),
                      trailing: a.notes != null && a.notes!.isNotEmpty
                          ? Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                      onTap: () {
                        // Optionally show details
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(a.type ?? 'Activity'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${a.date}'),
                                if (a.cattleName != null)
                                  Text('Cattle: ${a.cattleName}'),
                                if (a.notes != null && a.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text('Notes: ${a.notes}'),
                                ],
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<Uint8List?> _captureChart(GlobalKey key) async {
  try {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}

void _exportReportAsPdf(BuildContext context) async {
  final filter = context.read<FilterState>();
  final cattleVM = context.read<CattleViewModel>();
  final milkVM = context.read<MilkViewModel>();
  final activitiesVM = context.read<ActivitiesViewModel>();
  final range =
      filter.dateRange ??
      DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month, 1),
        end: DateTime.now(),
      );
  final filteredCattle = filter.status == 'All'
      ? cattleVM.cattleList
      : cattleVM.cattleList
            .where((c) => c.status.toLowerCase() == filter.status.toLowerCase())
            .toList();
  final filteredMilk = milkVM.milkList.where((m) {
    final d = DateTime.parse(m.date);
    return !d.isBefore(range.start) && !d.isAfter(range.end);
  }).toList();
  final filteredActivities = activitiesVM.activityList.where((a) {
    try {
      final d = DateTime.parse(a.date);
      return !d.isBefore(range.start) && !d.isAfter(range.end);
    } catch (_) {
      return false;
    }
  }).toList();

  // Capture chart images
  final popImg = await _captureChart(_CattleReportBody._populationChartKey);
  final milkImg = await _captureChart(_CattleReportBody._milkTrendChartKey);
  final breedImg = await _captureChart(_CattleReportBody._breedChartKey);
  final ageImg = await _captureChart(_CattleReportBody._ageChartKey);
  final topProdImg = await _captureChart(
    _CattleReportBody._topProducersChartKey,
  );

  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context ctx) => [
        // Branding/logo placeholder
        // pw.Image(pw.MemoryImage(logoBytes), height: 40),
        pw.Text(
          'Cattle Report',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Farm: ${context.read<CurrentFarm>().farm?.name ?? ''}'),
        pw.Text(
          'Date Range: ${range.start.toString().split(' ').first} - ${range.end.toString().split(' ').first}',
        ),
        pw.Text('Status: ${filter.status}'),
        pw.SizedBox(height: 16),
        pw.Text(
          'Summary',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.Bullet(text: 'Total Cattle: ${filteredCattle.length}'),
        pw.Bullet(text: 'Milk Records: ${filteredMilk.length}'),
        pw.Bullet(text: 'Activities: ${filteredActivities.length}'),
        pw.SizedBox(height: 16),
        pw.Text(
          'Population Breakdown',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (popImg != null) pw.Image(pw.MemoryImage(popImg), height: 180),
        pw.SizedBox(height: 8),
        pw.Text(
          'Cattle List',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Table.fromTextArray(
          headers: ['Tag', 'Name', 'Breed', 'Status', 'DOB'],
          data: [
            for (final c in filteredCattle)
              [c.tag, c.name, c.breed, c.status, c.dob],
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          'Milk Production Trend',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (milkImg != null) pw.Image(pw.MemoryImage(milkImg), height: 180),
        pw.SizedBox(height: 8),
        pw.Text(
          'Milk Records',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Table.fromTextArray(
          headers: ['Date', 'Cow', 'Total (L)'],
          data: [
            for (final m in filteredMilk)
              [
                m.date,
                (m.cowName == null || m.cowName!.isEmpty)
                    ? 'Entire Farm'
                    : (m.cowId != null && m.cowId!.isNotEmpty)
                    ? '${m.cowName!}-${m.cowId!}'
                    : m.cowName!,
                (m.total ?? 0).toStringAsFixed(1),
              ],
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          'Breed Distribution',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (breedImg != null) pw.Image(pw.MemoryImage(breedImg), height: 180),
        pw.SizedBox(height: 16),
        pw.Text(
          'Age Distribution',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (ageImg != null) pw.Image(pw.MemoryImage(ageImg), height: 180),
        pw.SizedBox(height: 16),
        pw.Text(
          'Top Producers',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (topProdImg != null)
          pw.Image(pw.MemoryImage(topProdImg), height: 180),
        pw.SizedBox(height: 16),
        pw.Text(
          'Recent Activities',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Table.fromTextArray(
          headers: ['Date', 'Type', 'Cattle', 'Notes'],
          data: [
            for (final a in filteredActivities)
              [a.date, a.type ?? '', a.cattleName ?? '', a.notes ?? ''],
          ],
        ),
      ],
    ),
  );
  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}
