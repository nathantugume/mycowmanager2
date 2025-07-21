import 'dart:core';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/financial_entry/financial_entry.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/income_view_model.dart';
import 'add_finance.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});
  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  late final IncomeViewModel _incomeViewModel;
  late final ExpenseViewModel _expenseViewModel;
  // Income tab filters
  DateTime? _incomeFilterStartDate;
  DateTime? _incomeFilterEndDate;
  String? _incomeFilterCategory;
  String? _incomeFilterTitle;
  String? _incomeFilterSource;
  double? _incomeFilterMinAmount;
  double? _incomeFilterMaxAmount;
  // Expense tab filters
  DateTime? _expenseFilterStartDate;
  DateTime? _expenseFilterEndDate;
  String? _expenseFilterCategory;
  String? _expenseFilterTitle;
  String? _expenseFilterExpenseType;
  double? _expenseFilterMinAmount;
  double? _expenseFilterMaxAmount;
  bool _isExporting = false;
  int _currentTab = 0;
  bool _isFiltering = false;
  bool _isReloading = false;

  @override
  void initState() {
    super.initState();
    _incomeViewModel = IncomeViewModel();
    _expenseViewModel = ExpenseViewModel();
    // kick off the fetch once
    _incomeViewModel.getAll(); // or fetchAll() if you renamed it
    _expenseViewModel.getAll(); // or fetchAll() if you renamed it
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finance'),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.south), text: 'Income'),
              Tab(icon: Icon(Icons.north), text: 'Expense'),
            ],
            onTap: (index) {
              setState(() => _currentTab = index);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () async {
                setState(() {
                  if (_currentTab == 0) {
                    _incomeFilterCategory = null;
                    _incomeFilterTitle = null;
                    _incomeFilterSource = null;
                    _incomeFilterMinAmount = null;
                    _incomeFilterMaxAmount = null;
                    _incomeFilterStartDate = null;
                    _incomeFilterEndDate = null;
                  } else {
                    _expenseFilterCategory = null;
                    _expenseFilterTitle = null;
                    _expenseFilterExpenseType = null;
                    _expenseFilterMinAmount = null;
                    _expenseFilterMaxAmount = null;
                    _expenseFilterStartDate = null;
                    _expenseFilterEndDate = null;
                  }
                });
                await _incomeViewModel.getAll();
                await _expenseViewModel.getAll();
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter',
              onPressed: () async {
                final isIncomeTab = _currentTab == 0;
                final vm = isIncomeTab ? _incomeViewModel : _expenseViewModel;
                final entries = isIncomeTab
                    ? (vm as IncomeViewModel).incomeList
                    : (vm as ExpenseViewModel).expenseList;
                final categories = entries
                    .map((e) => e.category ?? '')
                    .where((c) => c.isNotEmpty)
                    .toSet()
                    .toList();
                final expenseTypes = !isIncomeTab
                    ? (entries as List<ExpenseEntry>)
                          .map((e) => e.expenseType)
                          .toSet()
                          .toList()
                    : <String>[];
                final sources = isIncomeTab
                    ? (entries as List<IncomeEntry>)
                          .map((e) => e.source)
                          .toSet()
                          .toList()
                    : <String>[];
                final amounts = entries.map((e) => e.amount).toList();
                final minAmount = amounts.isEmpty
                    ? 0.0
                    : amounts.reduce((a, b) => a < b ? a : b);
                final maxAmount = amounts.isEmpty
                    ? 100.0
                    : amounts.reduce((a, b) => a > b ? a : b);
                RangeValues amountRange = RangeValues(
                  isIncomeTab
                      ? (_incomeFilterMinAmount ?? minAmount)
                      : (_expenseFilterMinAmount ?? minAmount),
                  isIncomeTab
                      ? (_incomeFilterMaxAmount ?? maxAmount)
                      : (_expenseFilterMaxAmount ?? maxAmount),
                );
                String? selectedCategory = isIncomeTab
                    ? _incomeFilterCategory
                    : _expenseFilterCategory;
                String? titleSearch = isIncomeTab
                    ? _incomeFilterTitle
                    : _expenseFilterTitle;
                String? selectedExpenseType = _expenseFilterExpenseType;
                String? selectedSource = _incomeFilterSource;
                DateTime? startDate = isIncomeTab
                    ? _incomeFilterStartDate
                    : _expenseFilterStartDate;
                DateTime? endDate = isIncomeTab
                    ? _incomeFilterEndDate
                    : _expenseFilterEndDate;
                final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (ctx) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        bool isFiltering = false;
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField<String?>(
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedCategory,
                                  items:
                                      [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                      ] +
                                      categories
                                          .map(
                                            (c) => DropdownMenuItem<String?>(
                                              value: c,
                                              child: Text(c),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    setModalState(() => selectedCategory = val);
                                  },
                                ),
                                if (!isIncomeTab) ...[
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String?>(
                                    decoration: const InputDecoration(
                                      labelText: 'Expense Type',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedExpenseType,
                                    items:
                                        [
                                          const DropdownMenuItem<String?>(
                                            value: null,
                                            child: Text('All'),
                                          ),
                                        ] +
                                        expenseTypes
                                            .map(
                                              (t) => DropdownMenuItem<String?>(
                                                value: t,
                                                child: Text(t),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (val) {
                                      setModalState(
                                        () => selectedExpenseType = val,
                                      );
                                    },
                                  ),
                                ],
                                if (isIncomeTab) ...[
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String?>(
                                    decoration: const InputDecoration(
                                      labelText: 'Source',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedSource,
                                    items:
                                        [
                                          const DropdownMenuItem<String?>(
                                            value: null,
                                            child: Text('All'),
                                          ),
                                        ] +
                                        sources
                                            .map(
                                              (s) => DropdownMenuItem<String?>(
                                                value: s,
                                                child: Text(s),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (val) {
                                      setModalState(() => selectedSource = val);
                                    },
                                  ),
                                ],
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: titleSearch,
                                  decoration: const InputDecoration(
                                    labelText: 'Title contains',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setModalState(() => titleSearch = val);
                                  },
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Amount: ${amountRange.start.toStringAsFixed(0)} - ${amountRange.end.toStringAsFixed(0)}',
                                ),
                                RangeSlider(
                                  min: minAmount,
                                  max: maxAmount,
                                  divisions: (maxAmount - minAmount).toInt() > 0
                                      ? (maxAmount - minAmount).toInt()
                                      : null,
                                  values: amountRange,
                                  onChanged: (RangeValues values) {
                                    setModalState(() {
                                      amountRange = values;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        (startDate == null || endDate == null)
                                            ? 'Range: Not selected'
                                            : 'Range: ${startDate!.toLocal().toString().split(' ')[0]} - ${endDate!.toLocal().toString().split(' ')[0]}',
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final picked =
                                            await showDateRangePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                              initialDateRange:
                                                  (startDate != null &&
                                                      endDate != null)
                                                  ? DateTimeRange(
                                                      start: startDate!,
                                                      end: endDate!,
                                                    )
                                                  : null,
                                            );
                                        if (picked != null) {
                                          setModalState(() {
                                            startDate = picked.start;
                                            endDate = picked.end;
                                          });
                                        }
                                      },
                                      child: const Text('Select Range'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setModalState(() => isFiltering = true);
                                        await Future.delayed(
                                          const Duration(milliseconds: 500),
                                        );
                                        Navigator.pop(ctx, {
                                          'category': selectedCategory,
                                          'title': titleSearch,
                                          'startDate': startDate,
                                          'endDate': endDate,
                                          'expenseType': selectedExpenseType,
                                          'source': selectedSource,
                                          'minAmount': amountRange.start,
                                          'maxAmount': amountRange.end,
                                        });
                                        setModalState(
                                          () => isFiltering = false,
                                        );
                                      },
                                      child: const Text('Apply'),
                                    ),
                                  ],
                                ),
                                if (isFiltering)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
                if (result != null) {
                  setState(() => _isReloading = true);
                  if (_currentTab == 0) {
                    await _incomeViewModel.getAll();
                  } else {
                    await _expenseViewModel.getAll();
                  }
                  setState(() {
                    if (_currentTab == 0) {
                      _incomeFilterCategory = result['category'];
                      _incomeFilterTitle = result['title'];
                      _incomeFilterSource = result['source'];
                      _incomeFilterMinAmount = result['minAmount'];
                      _incomeFilterMaxAmount = result['maxAmount'];
                      _incomeFilterStartDate = result['startDate'];
                      _incomeFilterEndDate = result['endDate'];
                    } else {
                      _expenseFilterCategory = result['category'];
                      _expenseFilterTitle = result['title'];
                      _expenseFilterExpenseType = result['expenseType'];
                      _expenseFilterMinAmount = result['minAmount'];
                      _expenseFilterMaxAmount = result['maxAmount'];
                      _expenseFilterStartDate = result['startDate'];
                      _expenseFilterEndDate = result['endDate'];
                    }
                    _isReloading = false;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export to PDF',
              onPressed: () async {
                setState(() => _isExporting = true);
                final isIncomeTab = _currentTab == 0;
                final vm = isIncomeTab ? _incomeViewModel : _expenseViewModel;
                final entries = isIncomeTab
                    ? (vm as IncomeViewModel).incomeList
                    : (vm as ExpenseViewModel).expenseList;
                final filteredList = entries.where((entry) {
                  final entryDate = DateTime.tryParse(entry.date);
                  final matchesCategory = isIncomeTab
                      ? (_incomeFilterCategory == null ||
                            (entry.category ?? '') == _incomeFilterCategory)
                      : (_expenseFilterCategory == null ||
                            (entry.category ?? '') == _expenseFilterCategory);
                  final matchesTitle = isIncomeTab
                      ? (_incomeFilterTitle == null ||
                            (entry.title.toLowerCase().contains(
                              _incomeFilterTitle!.toLowerCase(),
                            )))
                      : (_expenseFilterTitle == null ||
                            (entry.title.toLowerCase().contains(
                              _expenseFilterTitle!.toLowerCase(),
                            )));
                  final matchesStart = isIncomeTab
                      ? (_incomeFilterStartDate == null ||
                            (entryDate != null &&
                                !entryDate.isBefore(_incomeFilterStartDate!)))
                      : (_expenseFilterStartDate == null ||
                            (entryDate != null &&
                                !entryDate.isBefore(_expenseFilterStartDate!)));
                  final matchesEnd = isIncomeTab
                      ? (_incomeFilterEndDate == null ||
                            (entryDate != null &&
                                !entryDate.isAfter(_incomeFilterEndDate!)))
                      : (_expenseFilterEndDate == null ||
                            (entryDate != null &&
                                !entryDate.isAfter(_expenseFilterEndDate!)));
                  final matchesMin = isIncomeTab
                      ? (_incomeFilterMinAmount == null ||
                            entry.amount >= _incomeFilterMinAmount!)
                      : (_expenseFilterMinAmount == null ||
                            entry.amount >= _expenseFilterMinAmount!);
                  final matchesMax = isIncomeTab
                      ? (_incomeFilterMaxAmount == null ||
                            entry.amount <= _incomeFilterMaxAmount!)
                      : (_expenseFilterMaxAmount == null ||
                            entry.amount <= _expenseFilterMaxAmount!);
                  final matchesExpenseType =
                      !isIncomeTab ||
                      _expenseFilterExpenseType == null ||
                      (entry as ExpenseEntry).expenseType ==
                          _expenseFilterExpenseType;
                  final matchesSource =
                      isIncomeTab &&
                      (_incomeFilterSource == null ||
                          (entry is IncomeEntry &&
                              entry.source == _incomeFilterSource));
                  return matchesCategory &&
                      matchesTitle &&
                      matchesStart &&
                      matchesEnd &&
                      matchesMin &&
                      matchesMax &&
                      matchesExpenseType &&
                      matchesSource;
                }).toList();
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            _currentTab == 0
                                ? 'Income Records'
                                : 'Expense Records',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 16),
                          pw.Table.fromTextArray(
                            headers: ['Title', 'Date', 'Category', 'Amount'],
                            data: filteredList
                                .map(
                                  (e) => [
                                    e.title,
                                    e.date,
                                    e.category ?? '',
                                    e.amount.toStringAsFixed(2),
                                  ],
                                )
                                .toList(),
                          ),
                        ],
                      );
                    },
                  ),
                );
                await Printing.layoutPdf(
                  onLayout: (format) async => pdf.save(),
                );
                if (mounted) setState(() => _isExporting = false);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                ChangeNotifierProvider<IncomeViewModel>.value(
                  value: _incomeViewModel,
                  child: const _IncomeTab(),
                ),
                ChangeNotifierProvider<ExpenseViewModel>.value(
                  value: _expenseViewModel,
                  child: const _ExpenseTab(),
                ),
              ],
            ),
            if (_isReloading)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (_isExporting)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Finance'),
          icon: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const AddFinanceRecordSheet(),
              ),
            );
            if (!context.mounted) return;
            // After the sheet closes, refresh the data:
            final farm = context.read<CurrentFarm>().farm;
            if (farm != null) {
              context.read<ExpenseViewModel>().getByFarmId(farm.id);
              context.read<IncomeViewModel>().getByFarmId(farm.id);
            }
          },
        ),
      ),
    );
  }
}
//tab widgets

/*────────────────────────  CARD  WIDGET  ──────────────────────────*/
class MoneyCard<T extends FinancialEntry> extends StatelessWidget {
  const MoneyCard({super.key, required this.entry, this.onTap, this.onMenuTap});

  final T entry;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final colour = entry is ExpenseEntry
        ? Colors.redAccent
        : Colors.green.shade700;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _text(context, entry.title, isBold: true),
                  _text(context, 'Date: ${entry.date}'),
                ],
              ),
            ),
            _text(
              context,
              '${entry is ExpenseEntry ? '-' : '+'}UGX\u00A0${entry.amount.toStringAsFixed(0)}',
              isBold: true,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showFinanceOptions(context, entry),
              color: colour,
            ),
          ],
        ),
      ),
    );
  }

  void _showFinanceOptions(BuildContext context, FinancialEntry entry) async {
    final isExpense = entry is ExpenseEntry;
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (result == 'edit') {
      // Open AddFinanceRecordSheet in edit mode
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddFinanceRecordSheet(initialEntry: entry),
        ),
      );
      if (!context.mounted) return;
      final farm = context.read<CurrentFarm>().farm;
      if (farm != null) {
        if (isExpense) {
          context.read<ExpenseViewModel>().getByFarmId(farm.id);
        } else {
          context.read<IncomeViewModel>().getByFarmId(farm.id);
        }
      }
    } else if (result == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Record'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirm == true) {
        if (isExpense) {
          await context.read<ExpenseViewModel>().delete(entry.id);
        } else {
          await context.read<IncomeViewModel>().delete(entry.id);
        }
        if (!context.mounted) return;
        final farm = context.read<CurrentFarm>().farm;
        if (farm != null) {
          if (isExpense) {
            context.read<ExpenseViewModel>().getByFarmId(farm.id);
          } else {
            context.read<IncomeViewModel>().getByFarmId(farm.id);
          }
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Record deleted')));
      }
    }
  }
}

/*────────────────────────  EXPENSE TAB  ───────────────────────────*/
class _ExpenseTab extends StatelessWidget {
  const _ExpenseTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(
      builder: (_, vm, __) {
        if (vm.error != null) {
          return Center(child: Text('⚠️ ${vm.error}'));
        }
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.expenseList.isEmpty) {
          return const Center(child: Text('No expenses yet'));
        }

        final filteredList = vm.expenseList.where((entry) {
          final entryDate = DateTime.tryParse(entry.date);
          final parent = context.findAncestorStateOfType<_FinanceScreenState>();
          final matchesCategory =
              parent?._expenseFilterCategory == null ||
              (entry.category ?? '') == parent?._expenseFilterCategory;
          final matchesTitle =
              parent?._expenseFilterTitle == null ||
              (entry.title.toLowerCase().contains(
                parent!._expenseFilterTitle!.toLowerCase(),
              ));
          final matchesStart =
              parent?._expenseFilterStartDate == null ||
              (entryDate != null &&
                  !entryDate.isBefore(parent!._expenseFilterStartDate!));
          final matchesEnd =
              parent?._expenseFilterEndDate == null ||
              (entryDate != null &&
                  !entryDate.isAfter(parent!._expenseFilterEndDate!));
          final matchesMin =
              parent?._expenseFilterMinAmount == null ||
              entry.amount >= parent!._expenseFilterMinAmount!;
          final matchesMax =
              parent?._expenseFilterMaxAmount == null ||
              entry.amount <= parent!._expenseFilterMaxAmount!;
          final matchesExpenseType =
              parent?._expenseFilterExpenseType == null ||
              (entry as ExpenseEntry).expenseType ==
                  parent!._expenseFilterExpenseType;
          return matchesCategory &&
              matchesTitle &&
              matchesStart &&
              matchesEnd &&
              matchesMin &&
              matchesMax &&
              matchesExpenseType;
        }).toList();

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (_, i) {
            final exp = filteredList[i];
            return MoneyCard<ExpenseEntry>(
              entry: exp,
              onTap: () {},
              onMenuTap: () {},
            );
          },
        );
      },
    );
  }
}

/*────────────────────────  INCOME TAB  ────────────────────────────*/
class _IncomeTab extends StatelessWidget {
  const _IncomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeViewModel>(
      builder: (_, vm, __) {
        if (vm.error != null) {
          return Center(child: Text('⚠️ ${vm.error}'));
        }
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.incomeList.isEmpty) {
          return const Center(child: Text('No income yet'));
        }

        final filteredList = vm.incomeList.where((entry) {
          final entryDate = DateTime.tryParse(entry.date);
          final parent = context.findAncestorStateOfType<_FinanceScreenState>();
          final matchesCategory =
              parent?._incomeFilterCategory == null ||
              (entry.category ?? '') == parent?._incomeFilterCategory;
          final matchesTitle =
              parent?._incomeFilterTitle == null ||
              (entry.title.toLowerCase().contains(
                parent!._incomeFilterTitle!.toLowerCase(),
              ));
          final matchesStart =
              parent?._incomeFilterStartDate == null ||
              (entryDate != null &&
                  !entryDate.isBefore(parent!._incomeFilterStartDate!));
          final matchesEnd =
              parent?._incomeFilterEndDate == null ||
              (entryDate != null &&
                  !entryDate.isAfter(parent!._incomeFilterEndDate!));
          final matchesMin =
              parent?._incomeFilterMinAmount == null ||
              entry.amount >= parent!._incomeFilterMinAmount!;
          final matchesMax =
              parent?._incomeFilterMaxAmount == null ||
              entry.amount <= parent!._incomeFilterMaxAmount!;
          final matchesSource =
              parent?._incomeFilterSource == null ||
              entry.source == parent!._incomeFilterSource;
          return matchesCategory &&
              matchesTitle &&
              matchesStart &&
              matchesEnd &&
              matchesMin &&
              matchesMax &&
              matchesSource;
        }).toList();

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (_, i) {
            final inc = filteredList[i];
            return MoneyCard<IncomeEntry>(
              entry: inc,
              onTap: () {},
              onMenuTap: () {},
            );
          },
        );
      },
    );
  }
}

/*────────────────────────  TEXT HELPER  ───────────────────────────*/
Text _text(BuildContext ctx, String value, {bool isBold = false}) {
  return Text(
    value,
    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
    ),
  );
}
