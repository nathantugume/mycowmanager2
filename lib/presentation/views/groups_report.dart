import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/groups_report_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class GroupsReportScreen extends StatelessWidget {
  const GroupsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farm = Provider.of<CurrentFarm>(context).farm;
    return ChangeNotifierProvider(
      create: (_) => GroupsReportViewModel()..fetchData(farm!.id),
      child: const _GroupsReportScreenBody(),
    );
  }
}

class _GroupsReportScreenBody extends StatefulWidget {
  const _GroupsReportScreenBody();

  @override
  State<_GroupsReportScreenBody> createState() =>
      _GroupsReportScreenBodyState();
}

class _GroupsReportScreenBodyState extends State<_GroupsReportScreenBody> {
  String? _selectedGroup;
  DateTimeRange? _selectedDateRange;
  String? _selectedStatus;

  // Keys for chart capture
  final GlobalKey _populationChartKey = GlobalKey();
  final GlobalKey _milkYieldChartKey = GlobalKey();

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

  Future<void> _exportToPdf(BuildContext context) async {
    final vm = context.read<GroupsReportViewModel>();
    final popImg = await _captureChart(_populationChartKey);
    final milkImg = await _captureChart(_milkYieldChartKey);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context ctx) => [
          pw.Text(
            'Groups Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          if (_selectedDateRange != null)
            pw.Text(
              'Date Range: ${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
            ),
          if (_selectedStatus != null) pw.Text('Status: $_selectedStatus'),
          pw.SizedBox(height: 16),
          pw.Text(
            'Group Population',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          if (popImg != null) pw.Image(pw.MemoryImage(popImg), height: 180),
          pw.SizedBox(height: 16),
          pw.Text(
            'Milk Yield per Group',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          if (milkImg != null) pw.Image(pw.MemoryImage(milkImg), height: 180),
          pw.SizedBox(height: 16),
          pw.Text(
            'Group Summary',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Table.fromTextArray(
            headers: [
              'Group',
              'Cattle Count',
              'Avg Age (yrs)',
              'Total Milk (L)',
            ],
            data: [
              for (final group in vm.groups)
                () {
                  final cattleInGroup = vm.cattle
                      .where((c) => c.cattleGroup == group.id)
                      .toList();
                  final cattleTagsInGroup = cattleInGroup
                      .map((c) => c.tag)
                      .toList();
                  final cattleCount = cattleInGroup.length;
                  final avgAge = cattleInGroup.isEmpty
                      ? 0
                      : cattleInGroup
                                .map((c) {
                                  try {
                                    return DateTime.now()
                                        .difference(DateTime.parse(c.dob))
                                        .inDays;
                                  } catch (_) {
                                    return 0;
                                  }
                                })
                                .reduce((a, b) => a + b) /
                            cattleCount /
                            365;
                  final totalMilk = vm.milkRecords
                      .where((r) => cattleTagsInGroup.contains(r.cowId))
                      .map((r) => r.total)
                      .fold(0.0, (a, b) => a + b);
                  return [
                    group.name,
                    cattleCount.toString(),
                    avgAge.toStringAsFixed(1),
                    totalMilk.toStringAsFixed(1),
                  ];
                }(),
            ],
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GroupsReportViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (vm.error != null) {
      return Scaffold(body: Center(child: Text(vm.error!)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () => _exportToPdf(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Group filter
                    DropdownButton<String>(
                      value: _selectedGroup,
                      hint: const Text('Group'),
                      items: vm.groups
                          .map(
                            (g) => DropdownMenuItem(
                              value: g.id,
                              child: Text(g.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => _selectedGroup = val);
                        vm.applyFilters(
                          groupId: val,
                          dateRange: _selectedDateRange,
                          status: _selectedStatus,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    // Date range filter
                    TextButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _selectedDateRange == null
                            ? 'Date Range'
                            : '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
                      ),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _selectedDateRange = picked);
                          vm.applyFilters(
                            groupId: _selectedGroup,
                            dateRange: picked,
                            status: _selectedStatus,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    // Status filter
                    DropdownButton<String>(
                      value: _selectedStatus,
                      hint: const Text('Status'),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                          value: 'Active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(value: 'Sold', child: Text('Sold')),
                        DropdownMenuItem(value: 'Dead', child: Text('Dead')),
                        DropdownMenuItem(
                          value: 'Archived',
                          child: Text('Archived'),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedStatus = val);
                        vm.applyFilters(
                          groupId: _selectedGroup,
                          dateRange: _selectedDateRange,
                          status: val,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Charts
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final vm = context.watch<GroupsReportViewModel>();
                  // Prepare data
                  final groupPopulation = vm.groups.map((group) {
                    final population = vm.cattle
                        .where((c) => c.cattleGroup == group.id)
                        .length;
                    return {'group': group.name, 'population': population};
                  }).toList();
                  final milkYieldPerGroup = vm.groups.map((group) {
                    final groupCattleTags = vm.cattle
                        .where((c) => c.cattleGroup == group.id)
                        .map((c) => c.tag)
                        .toList();
                    final groupMilkRecords = vm.milkRecords
                        .where((r) => groupCattleTags.contains(r.cowId))
                        .toList();
                    final yield = groupMilkRecords
                        .map((r) => r.total)
                        .fold(0.0, (a, b) => a + b);
                    return {'group': group.name, 'yield': yield};
                  }).toList();
                  final chartChildren = [
                    Expanded(
                      child: RepaintBoundary(
                        key: _populationChartKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SfCartesianChart(
                              title: ChartTitle(text: 'Group Population'),
                              primaryXAxis: CategoryAxis(),
                              series: [
                                ColumnSeries<Map<String, dynamic>, String>(
                                  dataSource: groupPopulation,
                                  xValueMapper: (data, _) =>
                                      data['group'] as String,
                                  yValueMapper: (data, _) =>
                                      data['population'] as int,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RepaintBoundary(
                        key: _milkYieldChartKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SfCircularChart(
                              title: ChartTitle(text: 'Milk Yield per Group'),
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.right,
                              ),
                              series: <PieSeries<Map<String, dynamic>, String>>[
                                PieSeries<Map<String, dynamic>, String>(
                                  dataSource: milkYieldPerGroup,
                                  xValueMapper: (data, _) =>
                                      data['group'] as String,
                                  yValueMapper: (data, _) =>
                                      data['yield'] as double,
                                  dataLabelMapper: (data, _) =>
                                      (data['yield'] as double).toStringAsFixed(
                                        1,
                                      ),
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                  return isWide
                      ? Row(children: chartChildren)
                      : Column(
                          children: chartChildren
                              .map(
                                (w) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: w,
                                ),
                              )
                              .toList(),
                        );
                },
              ),
              const SizedBox(height: 24),
              // Table header
              Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Group Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Cattle Count',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Avg Age (yrs)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Total Milk (L)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Table rows
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.groups.length,
                itemBuilder: (context, idx) {
                  final group = vm.groups[idx];
                  final cattleInGroup = vm.cattle
                      .where((c) => c.cattleGroup == group.id)
                      .toList();
                  final cattleTagsInGroup = cattleInGroup
                      .map((c) => c.tag)
                      .toList();
                  final cattleCount = cattleInGroup.length;
                  final avgAge = cattleInGroup.isEmpty
                      ? 0
                      : cattleInGroup
                                .map((c) {
                                  try {
                                    return DateTime.now()
                                        .difference(DateTime.parse(c.dob))
                                        .inDays;
                                  } catch (_) {
                                    return 0;
                                  }
                                })
                                .reduce((a, b) => a + b) /
                            cattleCount /
                            365;
                  final totalMilk = vm.milkRecords
                      .where((r) => cattleTagsInGroup.contains(r.cowId))
                      .map((r) => r.total)
                      .fold(0.0, (a, b) => a + b);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(group.name)),
                        Expanded(child: Text(cattleCount.toString())),
                        Expanded(child: Text(avgAge.toStringAsFixed(1))),
                        Expanded(child: Text(totalMilk.toStringAsFixed(1))),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
