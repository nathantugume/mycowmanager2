import 'dart:core';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/financial_entry/financial_entry.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/income_view_model.dart';

class FinanceScreen extends StatefulWidget{
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
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Finance'),
            bottom: const TabBar(
              tabs: [
                Tab(icon : Icon(Icons.south),text: 'Income'),
                Tab(icon: Icon(Icons.north),text: 'Expense'),
              ],
            ),
          ),
          body: TabBarView(
              children:[ 
                ChangeNotifierProvider<IncomeViewModel>.value(
                  value: _incomeViewModel,
                  child: const _IncomeTab(),
                
              ),
                ChangeNotifierProvider<ExpenseViewModel>.value(
                  value: _expenseViewModel,
                  child: const _ExpenseTab(),
                ),
              
              ]),
          floatingActionButton: FloatingActionButton.extended(
              label: const Text('Add Finance'),
              icon: const FaIcon(FontAwesomeIcons.plus),
              backgroundColor: Colors.blueAccent,
              onPressed: (){}),

        )
    );
  }

}
//tab widgets



/*────────────────────────  CARD  WIDGET  ──────────────────────────*/
class MoneyCard<T extends FinancialEntry> extends StatelessWidget {
  const MoneyCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onMenuTap,
  });

  final T entry;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final colour =
    entry is ExpenseEntry ? Colors.redAccent : Colors.green.shade700;

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
            BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, 2)),
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
              '${entry is ExpenseEntry ? '-' : '+'}UGX ${entry.amount.toStringAsFixed(0)}',
              isBold: true,
            ),
            const SizedBox(width: 8),
            if (onMenuTap != null)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: onMenuTap,
                color: colour,
              ),
          ],
        ),
      ),
    );
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
