import 'dart:core';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/financial_entry/financial_entry.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/income_view_model.dart';
import 'add_finance.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});
  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  late final IncomeViewModel _incomeViewModel;
  late final ExpenseViewModel _expenseViewModel;

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
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.south), text: 'Income'),
              Tab(icon: Icon(Icons.north), text: 'Expense'),
            ],
          ),
        ),
        body: TabBarView(
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

        return ListView.builder(
          itemCount: vm.expenseList.length,
          itemBuilder: (_, i) {
            final exp = vm.expenseList[i];
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

        return ListView.builder(
          itemCount: vm.incomeList.length,
          itemBuilder: (_, i) {
            final inc = vm.incomeList[i];
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
