import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/milk/milking_record.dart';
import '../../models/cattle/cattle.dart';
import '../../models/cattle_group/cattle_group.dart';
import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import '../viewmodels/milk_view_model.dart';
import '../viewmodels/cattle_group_view_model.dart';
import 'dart:async';

class AddMilkRecordSheet extends StatefulWidget {
  final MilkingRecord? initialRecord;
  const AddMilkRecordSheet({super.key, this.initialRecord});

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
  final ValueNotifier<double> _totalMilkNotifier = ValueNotifier(0);

  String _scope = 'Entire Farm';
  Cattle? _selectedCow;
  List<Cattle> _cattleList = [];

  Timer? _retryTimer;
  bool _hasRetried = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    final rec = widget.initialRecord;
    if (rec != null) {
      _dateCtrl.text = rec.date;
      _morningCtrl.text = rec.morning.toString();
      _afternoonCtrl.text = rec.afternoon.toString();
      _eveningCtrl.text = rec.evening.toString();
      _calfMilkCtrl.text = rec.milkForCalf.toString();
      _notesCtrl.text = rec.notes ?? '';
      _scope = rec.cowId != null ? 'Per Cow' : 'Entire Farm';
      // _selectedCow will be set in didChangeDependencies if needed
    } else {
      _morningCtrl.text = '0';
      _afternoonCtrl.text = '0';
      _eveningCtrl.text = '0';
      _calfMilkCtrl.text = '0';
      _dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    _morningCtrl.addListener(_updateTotal);
    _afternoonCtrl.addListener(_updateTotal);
    _eveningCtrl.addListener(_updateTotal);
    _calfMilkCtrl.addListener(_updateTotal);
    _updateTotal();
    _startTime = DateTime.now();
    _startRetryWatcher();
  }

  void _startRetryWatcher() {
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final farm = context.read<CurrentFarm>().farm;
      if (!_hasRetried &&
          farm == null &&
          elapsed > const Duration(seconds: 8)) {
        _hasRetried = true;
        context.read<FarmViewModel>().loadForCurrentUser();
        debugPrint("⏱ Retrying loadForCurrentUser...");
      }
      // Optionally, stop retrying after a certain time
      if (elapsed > const Duration(seconds: 15)) {
        timer.cancel();
      }
    });
  }

  void _updateTotal() {
    _totalMilkNotifier.value = _totalMilk;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final farm = context.read<CurrentFarm>().farm;
    if (farm != null) {
      context.read<CattleViewModel>().getByFarmId(farm.id);
      // If editing, set _selectedCow if needed
      if (widget.initialRecord != null && widget.initialRecord!.cowId != null) {
        final cattleVm = context.read<CattleViewModel>();
        final foundList = cattleVm.cattleList.where(
          (c) => c.tag == widget.initialRecord!.cowId,
        );
        if (foundList.isNotEmpty) {
          setState(() {
            _selectedCow = foundList.first;
          });
        }
      }
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

    final farmVm = context.read<CurrentFarm>().farm;
    final milkVm = context.read<MilkViewModel>();
    final farm = farmVm;

    if (farm == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Farm not selected')));
      return;
    }

    if (_scope == 'Per Cow' && _selectedCow == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a cow')));
      return;
    }

    // Get group info if per cow
    String? groupId;
    String? groupName;
    if (_scope == 'Per Cow' && _selectedCow != null) {
      groupId = _selectedCow!.cattleGroup; // should be the group ID
      final groupVm = context.read<CattleGroupViewModel>();
      final groupList = groupVm.cattleList
          .where((g) => g.id == groupId)
          .toList();
      groupName = groupList.isNotEmpty ? groupList.first.name : null;
    }

    final record = MilkingRecord(
      id: widget.initialRecord?.id ?? '',
      farmName: farm.name,
      farmId: farm.id,
      owner: farm.owner,
      cowId: _scope == 'Per Cow' ? _selectedCow?.tag : null,
      cowName: _scope == 'Per Cow' ? _selectedCow?.name : null,
      cattleGroupId: groupId,
      cattleGroupName: groupName,
      date: _dateCtrl.text,
      morning: _parse(_morningCtrl.text),
      afternoon: _parse(_afternoonCtrl.text),
      evening: _parse(_eveningCtrl.text),
      milkForCalf: _parse(_calfMilkCtrl.text),
      total: _totalMilk,
      notes: _notesCtrl.text,
      scope: _scope, // Always set scope to a non-null value
    );

    if (widget.initialRecord != null &&
        record.id != null &&
        record.id!.isNotEmpty) {
      await milkVm.update(record.id!, record);
    } else {
      await milkVm.add(record);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentFarm = context.watch<CurrentFarm>().farm;
    if (currentFarm == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final cattleVm = context.watch<CattleViewModel>();
    _cattleList = cattleVm.cattleList;
    final ifLoading = cattleVm.isLoading;

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
                  DropdownMenuItem(
                    value: 'Entire Farm',
                    child: Text('Entire Farm'),
                  ),
                  DropdownMenuItem(value: 'Per Cow', child: Text('Per Cow')),
                ],
                onChanged: (val) => setState(() {
                  _scope = val!;
                  _selectedCow = null;
                  _updateTotal();
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
                                  enabled: false,
                                  child: Text('No cows available'),
                                ),
                              ]
                            : _cattleList.map((c) {
                                return DropdownMenuItem(
                                  value: c,
                                  child: Text(c.name),
                                );
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
              ValueListenableBuilder<double>(
                valueListenable: _totalMilkNotifier,
                builder: (context, total, _) {
                  return Text(
                    'Total Milk: ${total.toStringAsFixed(2)} L',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
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
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
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
    _totalMilkNotifier.dispose();
    _retryTimer?.cancel();
    super.dispose();
  }
}
