import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/financial_entry/financial_entry.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profit & Loss Report'),
        // Optionally show farm name/logo here
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Filter Row (date range, type, category)
            _FilterRow(
              selectedRange: _selectedRange,
              onRangeChanged: (range) => setState(() => _selectedRange = range),
              selectedType: _selectedType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              selectedCategory: _selectedCategory,
              onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
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

            // 3. Chart Section (Income/Expense/Net Profit)
            _PnLChart(data: _buildChartData()),

            const SizedBox(height: 16),

            // 4. Table Section (detailed entries)
            Expanded(child: _PnLTable()),

            const SizedBox(height: 16),

            // 5. Export Row (checkbox + button)
            _ExportRow(),
          ],
        ),
      ),
    );
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
    return Row(
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
            Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Income')),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Expense')),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Both')),
          ],
        ),
        const SizedBox(width: 8),

        // Category Dropdown
        DropdownButton<String>(
          value: selectedCategory,
          hint: const Text('Category'),
          items: availableCategories
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              .toList(),
          onChanged: onCategoryChanged,
        ),
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _KpiCard(title: 'Total Income', value: totalIncome.toStringAsFixed(2)),
        _KpiCard(title: 'Total Expense', value: totalExpense.toStringAsFixed(2)),
        _KpiCard(title: 'Net Profit', value: netProfit.toStringAsFixed(2)),
      ],
    );
  }
}

class _PnLChart extends StatelessWidget {
  final List<PnLChartData> data;
  const _PnLChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  @override
  Widget build(BuildContext context) {
    // Use DataTable with filtered entry data
    return SingleChildScrollView(
      child: DataTable(
        columns: [/* Date, Title, Category, Amount, Type */],
        rows: [/* ... */],
      ),
    );
  }
}

class _ExportRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: /*...*/, onChanged: /*...*/),
        const Text('Include chart in PDF'),
        const Spacer(),
        ElevatedButton(
          onPressed: /* export logic */,
          child: const Text('Export to PDF'),
        ),
      ],
    );
  }
}

class PnLChartData {
  final String period; // e.g., '2024-06'
  final double income;
  final double expense;
  double get netProfit => income - expense;

  PnLChartData({required this.period, required this.income, required this.expense});
}

void _applyFilters() {
  // Filter incomes
  _filteredIncomes = _allIncomes.where((e) {
    final inRange = _selectedRange == null ||
        (DateTime.parse(e.date).isAfter(_selectedRange!.start.subtract(const Duration(days: 1))) &&
         DateTime.parse(e.date).isBefore(_selectedRange!.end.add(const Duration(days: 1))));
    final categoryMatch = _selectedCategory == null || e.category == _selectedCategory;
    final typeMatch = _selectedType == 'Income' || _selectedType == 'Both';
    return inRange && categoryMatch && typeMatch;
  }).toList();

  // Filter expenses
  _filteredExpenses = _allExpenses.where((e) {
    final inRange = _selectedRange == null ||
        (DateTime.parse(e.date).isAfter(_selectedRange!.start.subtract(const Duration(days: 1))) &&
         DateTime.parse(e.date).isBefore(_selectedRange!.end.add(const Duration(days: 1))));
    final categoryMatch = _selectedCategory == null || e.category == _selectedCategory;
    final typeMatch = _selectedType == 'Expense' || _selectedType == 'Both';
    return inRange && categoryMatch && typeMatch;
  }).toList();

  // Update KPIs
  _totalIncome = _filteredIncomes.fold(0, (sum, e) => sum + e.amount);
  _totalExpense = _filteredExpenses.fold(0, (sum, e) => sum + e.amount);

  // Update categories
  _updateAvailableCategories(_allIncomes, _allExpenses);

  setState(() {});
}