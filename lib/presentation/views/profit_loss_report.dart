import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/financial_entry/financial_entry.dart';
import '../viewmodels/income_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import 'widgets/kpi_card.dart';

class ProfitLossReportScreen extends StatefulWidget {
  const ProfitLossReportScreen({super.key});

  @override
  State<ProfitLossReportScreen> createState() => _ProfitLossReportScreenState();
}

class _ProfitLossReportScreenState extends State<ProfitLossReportScreen> {
  // State variables for filters, toggles, etc.
  DateTimeRange? _selectedRange;
  String _selectedType = 'Both'; // 'Income', 'Expense', 'Both'
  String? _selectedCategory;
  List<String> _availableCategories = [];

  double _totalIncome = 0;
  double _totalExpense = 0;
  double get _netProfit => _totalIncome - _totalExpense;

  List<IncomeEntry> _allIncomes = [];
  List<ExpenseEntry> _allExpenses = [];
  List<IncomeEntry> _filteredIncomes = [];
  List<ExpenseEntry> _filteredExpenses = [];

  List<PnLChartData> _chartData = [];

  // For PDF export
  final GlobalKey _chartKey = GlobalKey();
  bool _includeChart = true;

  void _applyFilters() {
    // Log all incomes and expenses before filtering
    debugPrint('All incomes: \n');
    for (final e in _allIncomes) {
      debugPrint(e.toString());
    }
    debugPrint('All expenses: \n');
    for (final e in _allExpenses) {
      debugPrint(e.toString());
    }

    // Filter incomes
    _filteredIncomes = _allIncomes.where((e) {
      final inRange =
          _selectedRange == null ||
          (DateTime.parse(e.date).isAfter(
                _selectedRange!.start.subtract(const Duration(days: 1)),
              ) &&
              DateTime.parse(
                e.date,
              ).isBefore(_selectedRange!.end.add(const Duration(days: 1))));
      final categoryMatch =
          _selectedCategory == null || e.category == _selectedCategory;
      final typeMatch = _selectedType == 'Income' || _selectedType == 'Both';
      return inRange && categoryMatch && typeMatch;
    }).toList();

    // Filter expenses
    _filteredExpenses = _allExpenses.where((e) {
      final inRange =
          _selectedRange == null ||
          (DateTime.parse(e.date).isAfter(
                _selectedRange!.start.subtract(const Duration(days: 1)),
              ) &&
              DateTime.parse(
                e.date,
              ).isBefore(_selectedRange!.end.add(const Duration(days: 1))));
      final categoryMatch =
          _selectedCategory == null || e.category == _selectedCategory;
      final typeMatch = _selectedType == 'Expense' || _selectedType == 'Both';
      return inRange && categoryMatch && typeMatch;
    }).toList();

    // Log filtered lists
    debugPrint('Filtered incomes: \n');
    for (final e in _filteredIncomes) {
      debugPrint(e.toString());
    }
    debugPrint('Filtered expenses: \n');
    for (final e in _filteredExpenses) {
      debugPrint(e.toString());
    }

    // Update KPIs
    _totalIncome = _filteredIncomes.fold(0, (sum, e) => sum + e.amount);
    _totalExpense = _filteredExpenses.fold(0, (sum, e) => sum + e.amount);
    debugPrint(
      'Total income: $_totalIncome, Total expense: $_totalExpense, Net profit: $_netProfit',
    );

    // Update categories
    _updateAvailableCategories();
    _chartData = _buildChartData();

    setState(() {});
  }

  void _updateAvailableCategories() {
    final incomeCats = _allIncomes.map((e) => e.category);
    final expenseCats = _allExpenses.map((e) => e.category);
    _availableCategories = {...incomeCats, ...expenseCats}.toList()..sort();
  }

  List<PnLChartData> _buildChartData() {
    final Map<String, double> incomeMap = {};
    final Map<String, double> expenseMap = {};

    for (final e in _filteredIncomes) {
      final period = DateFormat('yyyy-MM').format(DateTime.parse(e.date));
      incomeMap[period] = (incomeMap[period] ?? 0) + e.amount;
    }
    for (final e in _filteredExpenses) {
      final period = DateFormat('yyyy-MM').format(DateTime.parse(e.date));
      expenseMap[period] = (expenseMap[period] ?? 0) + e.amount;
    }

    final allPeriods = {...incomeMap.keys, ...expenseMap.keys}.toList()..sort();
    return allPeriods.map((period) {
      return PnLChartData(
        period: period,
        income: incomeMap[period] ?? 0,
        expense: expenseMap[period] ?? 0,
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farm = context.read<CurrentFarm>().farm;
      if (farm != null) {
        context.read<IncomeViewModel>().getByFarmId(farm.id).then((_) {
          if (!mounted) return;
          final incomes = context.read<IncomeViewModel>().incomeList;
          debugPrint('Fetched incomes from ViewModel:');
          for (final e in incomes) {
            debugPrint(e.toString());
          }
          setState(() {
            _allIncomes = List<IncomeEntry>.from(incomes);
            _applyFilters();
          });
        });
        context.read<ExpenseViewModel>().getByFarmId(farm.id).then((_) {
          if (!mounted) return;
          final expenses = context.read<ExpenseViewModel>().expenseList;
          debugPrint('Fetched expenses from ViewModel:');
          for (final e in expenses) {
            debugPrint(e.toString());
          }
          setState(() {
            _allExpenses = List<ExpenseEntry>.from(expenses);
            _applyFilters();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profit & Loss Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: _exportToPdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Filter Row (date range, type, category)
            _FilterRow(
              selectedRange: _selectedRange,
              onRangeChanged: (range) {
                setState(() {
                  _selectedRange = range;
                  _applyFilters();
                });
              },
              selectedType: _selectedType,
              onTypeChanged: (type) {
                setState(() {
                  _selectedType = type;
                  _applyFilters();
                });
              },
              selectedCategory: _selectedCategory,
              onCategoryChanged: (cat) {
                setState(() {
                  _selectedCategory = cat;
                  _applyFilters();
                });
              },
              availableCategories: _availableCategories,
            ),

            const SizedBox(height: 16),

            // 2. KPI Row (Total Income, Total Expense, Net Profit)
            _KpiRow(
              totalIncome: _totalIncome,
              totalExpense: _totalExpense,
              netProfit: _netProfit,
            ),

            const SizedBox(height: 16),

            // 2.5. Include chart in PDF switch
            SwitchListTile(
              value: _includeChart,
              onChanged: (value) => setState(() => _includeChart = value),
              title: const Text('Include chart in PDF'),
              contentPadding: EdgeInsets.zero,
            ),

            // 3. Chart Section (Income/Expense/Net Profit)
            RepaintBoundary(
              key: _chartKey,
              child: _PnLChart(data: _chartData),
            ),

            const SizedBox(height: 16),

            // 4. Table Section (detailed entries)
            _PnLTable(
              entries: [..._filteredIncomes, ..._filteredExpenses]
                ..sort((a, b) => b.date.compareTo(a.date)),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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

  Future<void> _exportToPdf() async {
    final chartImg = _includeChart ? await _captureChart(_chartKey) : null;
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context ctx) => [
          pw.Text(
            'Profit & Loss Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          if (_selectedRange != null)
            pw.Text(
              'Date Range: ${_selectedRange!.start.toString().split(' ')[0]} - ${_selectedRange!.end.toString().split(' ')[0]}',
            ),
          if (_selectedType != 'Both') pw.Text('Type: $_selectedType'),
          if (_selectedCategory != null)
            pw.Text('Category: $_selectedCategory'),
          pw.SizedBox(height: 16),
          pw.Text('KPIs', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: 'Total Income: ${_totalIncome.toStringAsFixed(2)}'),
          pw.Bullet(text: 'Total Expense: ${_totalExpense.toStringAsFixed(2)}'),
          pw.Bullet(text: 'Net Profit: ${_netProfit.toStringAsFixed(2)}'),
          pw.SizedBox(height: 16),
          if (chartImg != null) ...[
            pw.Text(
              'Income/Expense/Net Profit Chart',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Image(pw.MemoryImage(chartImg), height: 200),
            pw.SizedBox(height: 16),
          ],
          pw.Text(
            'Entries',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Category', 'Amount', 'Type'],
            data: [
              for (final entry in [
                ..._filteredIncomes,
                ..._filteredExpenses,
              ]..sort((a, b) => b.date.compareTo(a.date)))
                [
                  entry.date,
                  entry.category,
                  entry.amount.toStringAsFixed(2),
                  entry is IncomeEntry ? 'Income' : 'Expense',
                ],
            ],
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}

class _FilterRow extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final String selectedType;
  final ValueChanged<String> onTypeChanged;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final List<String> availableCategories;

  const _FilterRow({
    required this.selectedRange,
    required this.onRangeChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.availableCategories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Date Range Picker
          TextButton.icon(
            icon: Icon(Icons.date_range),
            label: Text(_formatRange(selectedRange)),
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 1),
                initialDateRange: selectedRange,
              );
              if (picked != null) onRangeChanged(picked);
            },
          ),
          const SizedBox(width: 8),

          // Entry Type Toggle
          ToggleButtons(
            isSelected: [
              selectedType == 'Income',
              selectedType == 'Expense',
              selectedType == 'Both',
            ],
            onPressed: (index) {
              final types = ['Income', 'Expense', 'Both'];
              onTypeChanged(types[index]);
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Income'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Expense'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Both'),
              ),
            ],
          ),
          const SizedBox(width: 8),

          // Category Dropdown
          DropdownButton<String?>(
            value: selectedCategory,
            hint: const Text('Category'),
            items: [
              const DropdownMenuItem<String?>(value: null, child: Text('All')),
              ...availableCategories.map(
                (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
              ),
            ],
            onChanged: onCategoryChanged,
          ),
        ],
      ),
    );
  }

  String _formatRange(DateTimeRange? range) {
    if (range == null) return 'Select Range';
    final format = DateFormat('MMM d, yyyy');
    return '${format.format(range.start)} - ${format.format(range.end)}';
  }
}

class _KpiRow extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netProfit;

  const _KpiRow({
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    if (isSmall) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KpiCard(title: 'Total Income', value: totalIncome.toStringAsFixed(2)),
          const SizedBox(height: 8),
          KpiCard(
            title: 'Total Expense',
            value: totalExpense.toStringAsFixed(2),
          ),
          const SizedBox(height: 8),
          KpiCard(title: 'Net Profit', value: netProfit.toStringAsFixed(2)),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        KpiCard(title: 'Total Income', value: totalIncome.toStringAsFixed(2)),
        KpiCard(title: 'Total Expense', value: totalExpense.toStringAsFixed(2)),
        KpiCard(title: 'Net Profit', value: netProfit.toStringAsFixed(2)),
      ],
    );
  }
}

class _PnLChart extends StatelessWidget {
  final List<PnLChartData> data;
  const _PnLChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<PnLChartData, String>>[
          ColumnSeries<PnLChartData, String>(
            name: 'Income',
            dataSource: data,
            xValueMapper: (d, _) => d.period,
            yValueMapper: (d, _) => d.income,
            color: Colors.green,
          ),
          ColumnSeries<PnLChartData, String>(
            name: 'Expense',
            dataSource: data,
            xValueMapper: (d, _) => d.period,
            yValueMapper: (d, _) => d.expense,
            color: Colors.red,
          ),
          LineSeries<PnLChartData, String>(
            name: 'Net Profit',
            dataSource: data,
            xValueMapper: (d, _) => d.period,
            yValueMapper: (d, _) => d.netProfit,
            color: Colors.blue,
            markerSettings: MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class _PnLTable extends StatelessWidget {
  final List<FinancialEntry> entries;

  const _PnLTable({required this.entries});

  @override
  Widget build(BuildContext context) {
    // Use DataTable with filtered entry data
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Type')),
        ],
        rows: entries.map((entry) {
          final isIncome = entry is IncomeEntry;
          return DataRow(
            cells: [
              DataCell(
                Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date)),
                ),
              ),
              DataCell(Text(entry.category)),
              DataCell(Text(entry.amount.toStringAsFixed(2))),
              DataCell(Text(isIncome ? 'Income' : 'Expense')),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class PnLChartData {
  final String period; // e.g., '2024-06'
  final double income;
  final double expense;
  double get netProfit => income - expense;

  PnLChartData({
    required this.period,
    required this.income,
    required this.expense,
  });
}
