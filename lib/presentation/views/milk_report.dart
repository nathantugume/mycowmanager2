import 'dart:collection';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/repositories/milk_repository.dart';
import '../../models/milk/milking_record.dart';

/*───────────────────────────────────────────────────────────
  ENUM & HELPERS
 ───────────────────────────────────────────────────────────*/
final chartKey = GlobalKey();                 // declare above widget

enum MilkFilter { daily, weekly, monthly }

extension on MilkFilter {
  String get label => switch (this) {
    MilkFilter.daily   => 'Daily',
    MilkFilter.weekly  => 'Weekly',
    MilkFilter.monthly => 'Monthly',
  };
}

/// Aggregated stat per period bucket
class MilkStat {
  final String period;   // e.g. 2025‑07‑01 or 2025‑W27 or 2025‑07
  final double litres;
  MilkStat(this.period, this.litres);
}

/// Convert list → grouped & sorted list
List<MilkStat> bucketRecords(List<MilkingRecord> list, MilkFilter filter) {
  final map = SplayTreeMap<String, double>(); // keeps keys sorted
  for (final r in list) {
    final key = switch (filter) {
      MilkFilter.daily   => r.date,                             // yyyy‑MM‑dd
      MilkFilter.weekly  => _weekLabel(DateTime.parse(r.date)), // yyyy‑Www
      MilkFilter.monthly => r.date.substring(0, 7),             // yyyy‑MM
    };
    map.update(key, (v) => v + r.total, ifAbsent: () => r.total);
  }
  return [for (final e in map.entries) MilkStat(e.key, e.value)];
}

String _weekLabel(DateTime d) {
  final week = int.parse(DateFormat('w').format(d));
  return '${d.year}-W${week.toString().padLeft(2, '0')}';
}

/*───────────────────────────────────────────────────────────
  VIEWMODEL
 ───────────────────────────────────────────────────────────*/

class MilkReportViewModel extends ChangeNotifier {
  final _repo = MilkRepository();

  bool _loading = false;
  Exception? _error;
  List<MilkStat> _stats = [];
  MilkFilter _filter = MilkFilter.daily;

  bool get isLoading => _loading;
  Exception? get error => _error;
  List<MilkStat> get stats => _stats;
  MilkFilter get filter => _filter;

  Future<void> load(String farmId, {DateTimeRange? range}) async {
    _loading = true; _error = null; notifyListeners();
    try {
      final now = DateTime.now();
      final from = range?.start ?? now.subtract(const Duration(days: 90));
      final to   = range?.end   ?? now;
      final recs = await _repo.range(farmId: farmId, from: from, to: to);
      if (kDebugMode) {
        print(recs);
      }
      _stats = bucketRecords(recs, _filter);
    } catch (e) {
      _error = e is Exception ? e : Exception(e.toString());
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> saveAndOpenPdf(
      BuildContext context,
      pw.Document doc,                // the pdf.Document you created
          { String baseName = 'milk_report' }
      ) async {
    try {
      // ① Get sandbox‑safe documents directory
      final dir = await getApplicationDocumentsDirectory();

      // ② Build a unique file name e.g. milk_report_20250708_153012.pdf
      final ts   = DateTime.now();
      final file = File('${dir.path}/'
          '${baseName}_${ts.toIso8601String().replaceAll(RegExp(r'[:.]'), '')}.pdf');

      // ③ Write the PDF bytes
      await file.writeAsBytes(await doc.save());

      // ④ Notify user
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to ${file.path}')),
      );
      }

      // ⑤ Open or share it (printing works on both iOS & Android)
      await Printing.sharePdf(bytes: await file.readAsBytes(), filename: file.path.split('/').last);
      //   or using open_filex:
      // await OpenFilex.open(file.path);
    } catch (e) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF: $e')),
      );
      }
    }
  }


  void setFilter(MilkFilter f, String farmId) {
    _filter = f;
    load(farmId); // reload with new grouping
  }
}

/*───────────────────────────────────────────────────────────
  SCREEN WIDGET
 ───────────────────────────────────────────────────────────*/

class MilkReportScreen extends StatelessWidget {
  const MilkReportScreen({super.key, required this.farmId});
  final String farmId;





  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MilkReportViewModel()..load(farmId),
      child: _MilkReportBody(farmId),     // 🔹 removed const
    );
  }
}

/*────────────────────────────────────────────*/

class _MilkReportBody extends StatelessWidget {
  const _MilkReportBody(this.farmId);    // positional param OK
  final String farmId;

  @override
  Widget build(BuildContext context) {
    return Consumer<MilkReportViewModel>(
      builder: (ctx, vm, _) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Milk Reports'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: 'Export PDF',
                  onPressed: () {
                    final vm = context.read<MilkReportViewModel>();
                    final farmName = context.read<CurrentFarm>().farm?.name ?? 'Farm';
                    vm.exportAsPdf(context, farmName);
                  },
                ),
                PopupMenuButton<MilkFilter>(
                  onSelected: (f) => vm.setFilter(f, farmId),  // 🔹 just use farmId
                  itemBuilder: (_) => MilkFilter.values
                      .map((f) => PopupMenuItem(value: f, child: Text(f.label)))
                      .toList(),
                  icon: Row(
                    children: [
                      Text(vm.filter.label,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                      const Icon(Icons.filter_list),
                    ],
                  ),
                ),

              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Table'),
                  Tab(text: 'Bar'),
                  Tab(text: 'Trend'),
                ],
              ),
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                ? Center(child: Text('⚠️ ${vm.error}'))
                : TabBarView(
              children: [
                _TableTab(stats: vm.stats),
                _BarChartTab(stats: vm.stats),
                _LineChartTab(stats: vm.stats),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*───────────────────────────────────────────────────────────
  TABS
 ───────────────────────────────────────────────────────────*/

class _TableTab extends StatelessWidget {
  const _TableTab({required this.stats});
  final List<MilkStat> stats;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Period')),
          DataColumn(label: Text('Litres')),
        ],
        rows: stats
            .map((s) => DataRow(cells: [
          DataCell(Text(s.period)),
          DataCell(Text(s.litres.toStringAsFixed(1))),
        ]))
            .toList(),
      ),
    );
  }
}

class _BarChartTab extends StatelessWidget {
  const _BarChartTab({required this.stats});
  final List<MilkStat> stats;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: chartKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (v, meta) => Text(stats[v.toInt()].period),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            barGroups: [
              for (int i = 0; i < stats.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(toY: stats[i].litres, width: 12),
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class _LineChartTab extends StatelessWidget {
  const _LineChartTab({required this.stats});
  final List<MilkStat> stats;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: chartKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (v, meta) => Text(stats[v.toInt()].period),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (int i = 0; i < stats.length; i++)
                    FlSpot(i.toDouble(), stats[i].litres),
                ],
                isCurved: true,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


extension PdfExport on MilkReportViewModel {
  Future<void> exportAsPdf(BuildContext context, String farmName) async {
    if (stats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to export')),
      );
      return;
    }

    final doc = pw.Document();

    // optional: capture bar chart to PNG
    Uint8List? chartBytes;
    if (chartKey.currentContext != null) {
      final boundary =
      chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      chartBytes = bytes?.buffer.asUint8List();
    }
    doc.addPage(
      pw.Page(
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('$farmName  Milk Report (${filter.label})',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              // table
              pw.Table.fromTextArray(
                headers: const ['Period', 'Litres'],
                data: [
                  for (final s in stats)
                    [s.period, s.litres.toStringAsFixed(1)]
                ],
              ),
              if (chartBytes != null) ...[
                pw.SizedBox(height: 20),
                pw.Image(pw.MemoryImage(chartBytes), height: 200),
              ],
              pw.Spacer(),
              pw.Text(
                'Exported: ${DateFormat.yMMMd().format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => doc.save());
  }
}
