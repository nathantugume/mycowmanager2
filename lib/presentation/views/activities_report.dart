import 'package:flutter/material.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:mycowmanager/presentation/views/widgets/kpi_card.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';

import '../viewmodels/activities_report_view_model.dart';

class ActivitiesReportScreen extends StatelessWidget {
  const ActivitiesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farm = Provider.of<CurrentFarm>(context).farm;
    return ChangeNotifierProvider(
      create: (_) => ActivitiesReportViewModel()..fetchData(farm!.id),
      child: const _ActivitiesReportScreenBody(),
    );
  }
}

Future<void> _exportToPdf(BuildContext context) async {
  final vm = context.read<ActivitiesReportViewModel>();
  final activities = vm.activities;
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Text('Activities Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Activity Type', 'Cattle', 'By', 'Notes'],
            data: [
              for (final a in activities)
                [
                  a.date.split('T').first,
                  a.type,
                  a.cattleName ?? '',
                  a.performedBy ?? '',
                  (a.notes ?? '').length > 30
                      ? a.notes!.substring(0, 30) + '...'
                      : (a.notes ?? ''),
                ],
            ],
          ),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

class _ActivitiesReportScreenBody extends StatelessWidget {
  const _ActivitiesReportScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();

    if (vm.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Activities Report')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Activities Report')),
        body: Center(child: Text(vm.error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPdf(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Filter Row (activity type, date range, status)
            _FilterRow(),

            const SizedBox(height: 16),

            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.black45,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      tabs: [
                        Tab(text: 'Summary'),
                        Tab(text: 'Detailed'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Summary View
                          _SummaryView(),
                          // Detailed View
                          _ActivitiesTable(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatefulWidget {
  @override
  State<_FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<_FilterRow> {
  String? _selectedActivityType;
  DateTimeRange? _selectedDateRange;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();
    // Get distinct types from all activities
    final types = <String>{};
    for (final a in vm.activities) {
      if (a.type.isNotEmpty) types.add(a.type);
    }
    final activityTypes = ['All', ...types];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Activity type selection
          DropdownButton<String>(
            value: _selectedActivityType ?? 'All',
            hint: const Text('Select Type'),
            items: activityTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedActivityType = value;
              });
              vm.applyFilters(
                activityType: value == 'All' ? null : value,
                dateRange: _selectedDateRange,
              );
            },
          ),

          const SizedBox(width: 16),

          // Date range picker
          TextButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(
              _selectedDateRange == null
                  ? 'Select Date Range'
                  : '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
            ),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedDateRange = picked;
                });
                vm.applyFilters(
                  activityType: _selectedActivityType == 'All'
                      ? null
                      : _selectedActivityType,
                  dateRange: _selectedDateRange,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();
    final activities = vm.activities;
    final now = DateTime.now();
    final recentActivities = activities.where((a) {
      final date = DateTime.tryParse(a.date);
      return date != null &&
          date.isAfter(now.subtract(const Duration(days: 7)));
    }).toList();
    final typeCounts = <String, int>{};
    for (final a in activities) {
      typeCounts[a.type] = (typeCounts[a.type] ?? 0) + 1;
    }
    final mostCommonType = typeCounts.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .firstOrNull
        ?.key;
    final nextCheckup = activities
        .map((a) => a.nextCheckupDate)
        .whereType<String>()
        .map((d) => DateTime.tryParse(d))
        .whereType<DateTime>()
        .where((d) => d.isAfter(now))
        .sorted((a, b) => a.compareTo(b))
        .firstOrNull;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              KpiCard(
                title: 'Total Activities',
                value: activities.length.toString(),
              ),
              KpiCard(
                title: 'Recent (7d)',
                value: recentActivities.length.toString(),
              ),
              KpiCard(title: 'Types', value: typeCounts.length.toString()),
              if (mostCommonType != null)
                KpiCard(title: 'Most Common', value: mostCommonType),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Activities per Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 220,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries<dynamic, dynamic>>[
                ColumnSeries<dynamic, dynamic>(
                  dataSource: [
                    for (final entry in typeCounts.entries)
                      BarData(entry.key, entry.value),
                  ],
                  xValueMapper: (d, _) => d.type,
                  yValueMapper: (d, _) => d.count,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (nextCheckup != null)
            Card(
              color: Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.event_available, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text('Next scheduled checkup: '),
                    Text(
                      '${nextCheckup.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BarData {
  final String type;
  final int count;
  BarData(this.type, this.count);
}

class _Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();
    final activityTypes = vm.activities.map((a) => a.type).toSet().toList();
    final activityTypeDistribution = activityTypes.map((type) {
      final count = vm.activities.where((a) => a.type == type).length;
      return {'type': type, 'count': count};
    }).toList();

    final statusDistribution = [
      {
        'status': 'Completed',
        'count': vm.activities
            .where((a) => a.notes?.toLowerCase().contains('completed') ?? false)
            .length,
      },
      {
        'status': 'Pending',
        'count': vm.activities
            .where((a) => a.notes?.toLowerCase().contains('pending') ?? false)
            .length,
      },
    ];

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: SfCircularChart(
              title: const ChartTitle(text: 'Activity Type Distribution'),
              series: <CircularSeries>[
                PieSeries<Map<String, dynamic>, String>(
                  dataSource: activityTypeDistribution,
                  xValueMapper: (Map<String, dynamic> data, _) => data['type'],
                  yValueMapper: (Map<String, dynamic> data, _) => data['count'],
                ),
              ],
            ),
          ),
          Expanded(
            child: SfCircularChart(
              title: const ChartTitle(text: 'Status Distribution'),
              series: <CircularSeries>[
                PieSeries<Map<String, dynamic>, String>(
                  dataSource: statusDistribution,
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      data['status'],
                  yValueMapper: (Map<String, dynamic> data, _) => data['count'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitiesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Activity Type')),
          DataColumn(label: Text('Cattle')),
          DataColumn(label: Text('By')),
          DataColumn(label: Text('Notes')),
        ],
        rows: vm.activities.map((activity) {
          return DataRow(
            cells: [
              DataCell(Text(activity.date.split('T').first)),
              DataCell(Text(activity.type)),
              DataCell(Text(activity.cattleName ?? '')),
              DataCell(Text(activity.performedBy ?? '')),
              DataCell(
                Tooltip(
                  message: activity.notes ?? '',
                  child: Text(
                    (activity.notes ?? '').length > 20
                        ? activity.notes!.substring(0, 20) + '...'
                        : (activity.notes ?? ''),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
