import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/financial_entry/financial_entry.dart';
import '../viewmodels/farm_view_model.dart';
import '../viewmodels/income_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import 'dart:async';

class AddFinanceRecordSheet extends StatefulWidget {
  final FinancialEntry? initialEntry;
  const AddFinanceRecordSheet({super.key, this.initialEntry});

  @override
  State<AddFinanceRecordSheet> createState() => _AddFinanceRecordSheetState();
}

class _AddFinanceRecordSheetState extends State<AddFinanceRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _dateCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _expenseTypeCtrl = TextEditingController();

  String _type = 'Expense';
  Timer? _retryTimer;
  bool _hasRetried = false;
  bool _isLoading = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    if (entry != null) {
      _editingId = entry.id;
      _titleCtrl.text = entry.title;
      _amountCtrl.text = entry.amount.toString();
      _descriptionCtrl.text = entry.description ?? '';
      _dateCtrl.text = entry.date;
      if (entry is ExpenseEntry) {
        _type = 'Expense';
        _expenseTypeCtrl.text = entry.expenseType;
      } else if (entry is IncomeEntry) {
        _type = 'Income';
        _sourceCtrl.text = entry.source;
      }
    } else {
      _dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    _startRetryWatcher();
  }

  void _startRetryWatcher() {
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final farm = context.read<CurrentFarm>().farm;
      if (!_hasRetried && farm == null && timer.tick > 8) {
        _hasRetried = true;
        context.read<FarmViewModel>().loadForCurrentUser();
      }
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _dateCtrl.dispose();
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _descriptionCtrl.dispose();
    _sourceCtrl.dispose();
    super.dispose();
  }

  double _parseAmount(String? val) => double.tryParse(val ?? '') ?? 0;

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final farm = context.read<CurrentFarm>().farm;
    if (farm == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Farm not selected')));
      return;
    }
    if (_type == 'Expense') {
      final entry = FinancialEntry.expense(
        id: _editingId ?? '',
        title: _titleCtrl.text.trim(),
        amount: _parseAmount(_amountCtrl.text),
        category: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        date: _dateCtrl.text,
        farmId: farm.id,
        expenseType: _expenseTypeCtrl.text.trim().isEmpty
            ? _titleCtrl.text.trim()
            : _expenseTypeCtrl.text.trim(),
      );
      if (_editingId != null) {
        await context.read<ExpenseViewModel>().update(
          _editingId!,
          entry as ExpenseEntry,
        );
      } else {
        await context.read<ExpenseViewModel>().add(entry as ExpenseEntry);
      }
      if (!mounted) {
        setState(() => _isLoading = false);
        return;
      }
      final error = context.read<ExpenseViewModel>().error;
      if (error != null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save expense: $error')),
        );
        return;
      }
    } else {
      final entry = FinancialEntry.income(
        id: _editingId ?? '',
        title: _titleCtrl.text.trim(),
        amount: _parseAmount(_amountCtrl.text),
        category: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        date: _dateCtrl.text,
        farmId: farm.id,
        source: _sourceCtrl.text.trim(),
      );
      if (_editingId != null) {
        await context.read<IncomeViewModel>().update(
          _editingId!,
          entry as IncomeEntry,
        );
      } else {
        await context.read<IncomeViewModel>().add(entry as IncomeEntry);
      }
      if (!mounted) {
        setState(() => _isLoading = false);
        return;
      }
      final error = context.read<IncomeViewModel>().error;
      if (error != null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save income: $error')),
        );
        return;
      }
    }
    if (!mounted) {
      setState(() => _isLoading = false);
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final farm = context.watch<CurrentFarm>().farm;
    if (farm == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Expense', child: Text('Expense')),
                  DropdownMenuItem(value: 'Income', child: Text('Income')),
                ],
                onChanged: (val) => setState(() {
                  _type = val!;
                }),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Date'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              if (_type == 'Income')
                TextFormField(
                  controller: _sourceCtrl,
                  decoration: const InputDecoration(labelText: 'Source'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter a source'
                      : null,
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
