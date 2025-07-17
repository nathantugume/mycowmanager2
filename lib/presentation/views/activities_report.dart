import 'package:flutter/material.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:mycowmanager/presentation/views/widgets/kpi_card.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Text('Activities Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Activity', 'Type', 'Date', 'Status'],
            data: const [
              ['Activity 1', 'Milking', '2024-01-01', 'Completed'],
              ['Activity 2', 'Feeding', '2024-01-02', 'Pending'],
              ['Activity 3', 'Health Check', '2024-01-03', 'Completed'],
            ],
          ),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}

class _ActivitiesReportScreenBody extends StatelessWidget {
  const _ActivitiesReportScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();

    if (vm.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Activities Report'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (vm.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Activities Report'),
        ),
        body: Center(
          child: Text(vm.error!),
        ),
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

            // 2. KPI Row (total activities, completed, pending)
            _KpiRow(),

            const SizedBox(height: 16),

            // 3. Charts (activity type distribution, status distribution)
            _Charts(),

            const SizedBox(height: 16),

            // 4. Table (detailed entries)
            Expanded(child: _ActivitiesTable()),
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
    return Row(
      children: [
        // Activity type selection
        DropdownButton<String>(
          value: _selectedActivityType,
          hint: const Text('Select Type'),
          items: const [
            DropdownMenuItem(
              value: 'All',
              child: Text('All'),
            ),
            DropdownMenuItem(
              value: 'Milking',
              child: Text('Milking'),
            ),
            DropdownMenuItem(
              value: 'Feeding',
              child: Text('Feeding'),
            ),
            DropdownMenuItem(
              value: 'Health Check',
              child: Text('Health Check'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedActivityType = value;
            });
            context.read<ActivitiesReportViewModel>().applyFilters(
                  activityType: _selectedActivityType,
                  dateRange: _selectedDateRange,
                  status: _selectedStatus,
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
              context.read<ActivitiesReportViewModel>().applyFilters(
                    activityType: _selectedActivityType,
                    dateRange: _selectedDateRange,
                    status: _selectedStatus,
                  );
            }
          },
        ),

        const SizedBox(width: 16),

        // Status
        DropdownButton<String>(
          value: _selectedStatus,
          hint: const Text('Select Status'),
          items: const [
            DropdownMenuItem(
              value: 'All',
              child: Text('All'),
            ),
            DropdownMenuItem(
              value: 'Completed',
              child: Text('Completed'),
            ),
            DropdownMenuItem(
              value: 'Pending',
              child: Text('Pending'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
            context.read<ActivitiesReportViewModel>().applyFilters(
                  activityType: _selectedActivityType,
                  dateRange: _selectedDateRange,
                  status: _selectedStatus,
                );
          },
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();
    final totalActivities = vm.activities.length;
    final completedActivities =
        vm.activities.where((a) => a.isComplete).length;
    final pendingActivities = totalActivities - completedActivities;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        KpiCard(title: 'Total Activities', value: totalActivities.toString()),
        KpiCard(title: 'Completed', value: completedActivities.toString()),
        KpiCard(title: 'Pending', value: pendingActivities.toString()),
      ],
    );
  }
}

class _Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivitiesReportViewModel>();
    final activityTypes =
        vm.activities.map((a) => a.activityType).toSet().toList();
    final activityTypeDistribution = activityTypes.map((type) {
      final count =
          vm.activities.where((a) => a.activityType == type).length;
      return {'type': type, 'count': count};
    }).toList();

    final statusDistribution = [
      {
        'status': 'Completed',
        'count': vm.activities.where((a) => a.isComplete).length
      },
      {
        'status': 'Pending',
        'count': vm.activities.where((a) => !a.isComplete).length
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
                )
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
                )
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
    return DataTable(
      columns: const [
        DataColumn(label: Text('Activity')),
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Status')),
      ],
      rows: vm.activities.map((activity) {
        return DataRow(cells: [
          DataCell(Text(activity.title)),
          DataCell(Text(activity.activityType)),
          DataCell(Text(activity.date.toString().split(' ')[0])),
          DataCell(Text(activity.isComplete ? 'Completed' : 'Pending')),
        ]);
      }).toList(),
    );
  }
}
