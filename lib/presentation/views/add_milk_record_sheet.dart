import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/milk/milking_record.dart';
import '../../models/cattle/cattle.dart';
import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import '../viewmodels/milk_view_model.dart';

class AddMilkRecordSheet extends StatefulWidget {
  const AddMilkRecordSheet({super.key});

  @override
  State<AddMilkRecordSheet> createState() => _AddMilkRecordSheetState();
}

class _AddMilkRecordSheetState extends State<AddMilkRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _dateCtrl = TextEditingController();
  final _morningCtrl = TextEditingController();
  final _afternoonCtrl = TextEditingController();
  final _eveningCtrl = TextEditingController();
  final _calfMilkCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _scope = 'Entire Farm';
  Cattle? _selectedCow;
  List<Cattle> _cattleList = [];

  @override
  void initState() {
    super.initState();
    _morningCtrl.text = '0';
    _afternoonCtrl.text = '0';
    _eveningCtrl.text = '0';
    _calfMilkCtrl.text = '0';
    _dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final farm = context.read<CurrentFarm>().farm;
    if (farm != null) {
      context.read<CattleViewModel>().getByFarmId(farm.id);
    }
  }

  double _parse(String? val) => double.tryParse(val ?? '') ?? 0;

  double get _totalMilk {
    final m = _parse(_morningCtrl.text);
    final a = _parse(_afternoonCtrl.text);
    final e = _parse(_eveningCtrl.text);
    final c = _parse(_calfMilkCtrl.text);
    return (m + a + e) - c;
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final farmVm = context.watch<CurrentFarm>().farm;
    final milkVm = context.read<MilkViewModel>();
    final farm = farmVm;

    if (kDebugMode) {
      print(farm);
    }
    if (farm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm not selected')),
      );
      return;
    }

    if (_scope == 'Per Cow' && _selectedCow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cow')),
      );
      return;
    }

    final record = MilkingRecord(
      id: '',
      farmName: farm.name,
      farmId: farm.id,
      owner: farm.owner,
      cowId: _scope == 'Per Cow' ? _selectedCow?.tag : null,
      cowName: _scope == 'Per Cow' ? _selectedCow?.name : null,
      date: _dateCtrl.text,
      morning: _parse(_morningCtrl.text),
      afternoon: _parse(_afternoonCtrl.text),
      evening: _parse(_eveningCtrl.text),
      milkForCalf: _parse(_calfMilkCtrl.text),
      total: _totalMilk,
      notes: _notesCtrl.text,
    );

    await milkVm.add(record);

    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cattleVm = context.watch<CattleViewModel>();
    _cattleList = cattleVm.cattleList; // Update cattle list from view model
    final ifLoading = cattleVm.isLoading; // Assuming CattleViewModel has isLoading

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _scope,
                items: const [
                  DropdownMenuItem(value: 'Entire Farm', child: Text('Entire Farm')),
                  DropdownMenuItem(value: 'Per Cow', child: Text('Per Cow')),
                ],
                onChanged: (val) => setState(() {
                  _scope = val!;
                    _selectedCow = null; // Reset selected cow when scope changes
                }),
                decoration: const InputDecoration(labelText: 'Scope'),
              ),
              if (_scope == 'Per Cow')
                ifLoading
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<Cattle>(
                  value: _selectedCow,
                  items: _cattleList.isEmpty
                      ? [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No cows available'),
                      enabled: false,
                    )
                  ]
                      : _cattleList.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c.name));
                  }).toList(),
                  onChanged: (c) => setState(() => _selectedCow = c),
                  decoration: const InputDecoration(labelText: 'Cow'),
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
              _numField(_morningCtrl, 'Morning Milk (L)'),
              _numField(_afternoonCtrl, 'Afternoon Milk (L)'),
              _numField(_eveningCtrl, 'Evening Milk (L)'),
              _numField(_calfMilkCtrl, 'Milk for Calf (L)'),
              Text('Total Milk: ${_totalMilk.toStringAsFixed(2)} L',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _numField(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a value';
        if (double.tryParse(value) == null) return 'Please enter a valid number';
        return null;
      },
    );
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _morningCtrl.dispose();
    _afternoonCtrl.dispose();
    _eveningCtrl.dispose();
    _calfMilkCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
}