import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../viewmodels/groups_report_view_model.dart';
import 'widgets/kpi_card.dart';

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

Future<void> _exportToPdf(BuildContext context) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Text('Groups Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Group', 'Cattle Count', 'Avg Age', 'Total Milk Yield'],
            data: const [
              ['Group A', '10', '2.5', '100'],
              ['Group B', '15', '3.2', '150'],
              ['Group C', '8', '1.8', '80'],
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

class _GroupsReportScreenBody extends StatelessWidget {
  const _GroupsReportScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GroupsReportViewModel>();

    if (vm.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Groups Report'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (vm.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Groups Report'),
        ),
        body: Center(
          child: Text(vm.error!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups Report'),
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
            // 1. Filter Row (group selection, date range, cattle status)
            _FilterRow(),

            const SizedBox(height: 16),

            // 2. KPI Row (cattle count, avg age, total milk yield)
            _KpiRow(),

            const SizedBox(height: 16),

            // 3. Charts (group population distribution, milk yield per group)
            _Charts(),

            const SizedBox(height: 16),

            // 4. Table (detailed entries)
            Expanded(child: _GroupsTable()),
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
  String? _selectedGroup;
  DateTimeRange? _selectedDateRange;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GroupsReportViewModel>();
    return Row(
      children: [
        // Group selection
        DropdownButton<String>(
          value: _selectedGroup,
          hint: const Text('Select Group'),
          items: vm.groups.map((group) {
            return DropdownMenuItem(
              value: group.id,
              child: Text(group.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGroup = value;
            });
            context.read<GroupsReportViewModel>().applyFilters(
                  groupId: _selectedGroup,
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
              context.read<GroupsReportViewModel>().applyFilters(
                    groupId: _selectedGroup,
                    dateRange: _selectedDateRange,
                    status: _selectedStatus,
                  );
            }
          },
        ),

        const SizedBox(width: 16),

        // Cattle status
        DropdownButton<String>(
          value: _selectedStatus,
          hint: const Text('Select Status'),
          items: const [
            DropdownMenuItem(
              value: 'All',
              child: Text('All'),
            ),
            DropdownMenuItem(
              value: 'Active',
              child: Text('Active'),
            ),
            DropdownMenuItem(
              value: 'Sold',
              child: Text('Sold'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
            context.read<GroupsReportViewModel>().applyFilters(
                  groupId: _selectedGroup,
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
    final vm = context.watch<GroupsReportViewModel>();
    final cattleCount = vm.cattle.length;
    final avgAge = vm.cattle.isEmpty
        ? 0
        : vm.cattle
                .map((c) => DateTime.now().difference(c.dateOfBirth).inDays)
                .reduce((a, b) => a + b) /
            cattleCount /
            365;
    final totalMilkYield = vm.milkRecords.isEmpty
        ? 0
        : vm.milkRecords.map((r) => r.litres).reduce((a, b) => a + b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        KpiCard(title: 'Cattle Count', value: cattleCount.toString()),
        KpiCard(title: 'Avg Age', value: avgAge.toStringAsFixed(1)),
        KpiCard(
            title: 'Total Milk Yield', value: totalMilkYield.toStringAsFixed(1)),
      ],
    );
  }
}

class _Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GroupsReportViewModel>();
    final groupPopulation = vm.groups.map((group) {
      final population =
          vm.cattle.where((c) => c.groupId == group.id).length;
      return {'group': group.name, 'population': population};
    }).toList();

    final milkYieldPerGroup = vm.groups.map((group) {
      final groupCattleIds = vm.cattle
          .where((c) => c.groupId == group.id)
          .map((c) => c.id)
          .toList();
      final yield = vm.milkRecords
          .where((r) => groupCattleIds.contains(r.cattleId))
          .map((r) => r.litres)
          .fold(0.0, (a, b) => a + b);
      return {'group': group.name, 'yield': yield};
    }).toList();

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              title: const ChartTitle(text: 'Group Population'),
              series: <CartesianSeries>[
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: groupPopulation,
                  xValueMapper: (Map<String, dynamic> data, _) => data['group'],
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['population'],
                )
              ],
            ),
          ),
          Expanded(
            child: SfCircularChart(
              title: const ChartTitle(text: 'Milk Yield per Group'),
              series: <CircularSeries>[
                PieSeries<Map<String, dynamic>, String>(
                  dataSource: milkYieldPerGroup,
                  xValueMapper: (Map<String, dynamic> data, _) => data['group'],
                  yValueMapper: (Map<String, dynamic> data, _) => data['yield'],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GroupsReportViewModel>();
    return DataTable(
      columns: const [
        DataColumn(label: Text('Group')),
        DataColumn(label: Text('Cattle Count')),
        DataColumn(label: Text('Avg Age')),
        DataColumn(label: Text('Total Milk Yield')),
      ],
      rows: vm.groups.map((group) {
        final cattleInGroup =
            vm.cattle.where((c) => c.groupId == group.id).toList();
        final cattleCount = cattleInGroup.length;
        final avgAge = cattleInGroup.isEmpty
            ? 0
            : cattleInGroup
                    .map((c) => DateTime.now().difference(c.dateOfBirth).inDays)
                    .reduce((a, b) => a + b) /
                cattleCount /
                365;
        final totalMilkYield = vm.milkRecords
            .where((r) => cattleInGroup.any((c) => c.id == r.cattleId))
            .map((r) => r.litres)
            .fold(0.0, (a, b) => a + b);
        return DataRow(cells: [
          DataCell(Text(group.name)),
          DataCell(Text(cattleCount.toString())),
          DataCell(Text(avgAge.toStringAsFixed(1))),
          DataCell(Text(totalMilkYield.toStringAsFixed(1))),
        ]);
      }).toList(),
    );
  }
}
