import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycowmanager/models/activities/activity.dart';
import 'package:provider/provider.dart';

import '../viewmodels/activities_view_model.dart';
import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/farm_view_model.dart';

class ActivityFormController extends StatefulWidget {
  final Activity? existingActivity;
  const ActivityFormController({super.key, this.existingActivity});

  @override
  State<ActivityFormController> createState() => _ActivityFormControllerState();
}

class _ActivityFormControllerState extends State<ActivityFormController> {
  // ViewModels
  late final CattleViewModel _cattleVm;
  late final ActivitiesViewModel _activityVm;
  late final FarmViewModel _farmVm;

  // State
  bool _isLoading = false;

  // Controllers
  final _activityTypeCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _performedByCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _symptomsCtrl = TextEditingController();
  final _medicationsCtrl = TextEditingController();
  final _vaccineNameCtrl = TextEditingController();
  final _vaccineDoseCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _weightUnitCtrl = TextEditingController();
  final _breedingTypeCtrl = TextEditingController();
  final _sireTagCtrl = TextEditingController();

  String? _selectedActivityType;
  String? _selectedCowId;

  @override
  void initState() {
    super.initState();
    _farmVm = context.read<FarmViewModel>();
    _cattleVm = context.read<CattleViewModel>();
    _activityVm = context.read<ActivitiesViewModel>();

    _farmVm.loadForCurrentUser();
    if (widget.existingActivity != null) {
      final a = widget.existingActivity!;
      _activityTypeCtrl.text = a.type;
      _dateCtrl.text = a.date;
      _performedByCtrl.text = a.performedBy ?? '';
      _notesCtrl.text = a.notes ?? '';
      _diagnosisCtrl.text = a.diagnosis ?? '';
      _symptomsCtrl.text = a.symptoms?.join(', ') ?? '';
      _medicationsCtrl.text = a.medications?.join(', ') ?? '';
      _vaccineNameCtrl.text = a.vaccineName ?? '';
      _vaccineDoseCtrl.text = a.vaccineDose ?? '';
      _weightCtrl.text = a.weight ?? '';
      _weightUnitCtrl.text = a.weightUnit ?? '';
      _breedingTypeCtrl.text = a.breedingType ?? '';
      _sireTagCtrl.text = a.sireTag ?? '';
      _selectedActivityType = a.type;
      _selectedCowId = a.cattleId;
    } else {
      _dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  @override
  void dispose() {
    _activityTypeCtrl.dispose();
    _dateCtrl.dispose();
    _performedByCtrl.dispose();
    _notesCtrl.dispose();
    _diagnosisCtrl.dispose();
    _symptomsCtrl.dispose();
    _medicationsCtrl.dispose();
    _vaccineNameCtrl.dispose();
    _vaccineDoseCtrl.dispose();
    _weightCtrl.dispose();
    _weightUnitCtrl.dispose();
    _breedingTypeCtrl.dispose();
    _sireTagCtrl.dispose();

    super.dispose();
  }
  //
  // void _onActivityStatus() {
  //   final status = _activityVm.operationStatus.value;
  //   if (status.isNotEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
  //     _clearForm();
  //   }
  // }

  void _clearForm() {
    _activityTypeCtrl.clear();
    _performedByCtrl.clear();
    _notesCtrl.clear();
    _diagnosisCtrl.clear();
    _symptomsCtrl.clear();
    _medicationsCtrl.clear();
    _vaccineNameCtrl.clear();
    _vaccineDoseCtrl.clear();
    _weightCtrl.clear();
    _weightUnitCtrl.clear();
    _breedingTypeCtrl.clear();
    _sireTagCtrl.clear();

    _dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      _selectedActivityType = null;
      _selectedCowId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFarm = context.watch<CurrentFarm>().farm;
    final cattleList = context.watch<CattleViewModel>().cattleList;

    if (currentFarm == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // fetch cattle when farm becomes available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentFarm.id.isNotEmpty) {
        _cattleVm.getByFarmId(currentFarm.id);
      }
    });

    // Ensure selected cow is in the list, else set to null (but do NOT call setState here)
    final dropdownCowId = (cattleList.map((c) => c.id).contains(_selectedCowId))
        ? _selectedCowId
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _dropdown(
            _activityTypeCtrl,
            'Activity Type',
            ['Disease', 'Vaccination', 'Weighing', 'Breeding'],
            onChanged: (val) => setState(() => _selectedActivityType = val),
          ),

          _tf(
            _dateCtrl,
            'Date (yyyy-MM-dd)',
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
              }
            },
          ),

          _tf(_performedByCtrl, 'Performed By'),
          _tf(_notesCtrl, 'Notes'),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select Cow',
            ),
            value: dropdownCowId,
            items: cattleList.map((cattle) {
              return DropdownMenuItem(
                value: cattle.id,
                child: Text('${cattle.tag} - ${cattle.name}'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedCowId = val),
          ),
          const SizedBox(height: 10),

          if (_selectedActivityType?.toLowerCase() == 'disease') ...[
            _tf(_diagnosisCtrl, 'Diagnosis'),
            _tf(_symptomsCtrl, 'Symptoms'),
            _tf(_medicationsCtrl, 'Medications'),
          ],

          if (_selectedActivityType?.toLowerCase() == 'vaccination') ...[
            _tf(_vaccineNameCtrl, 'Vaccine Name'),
            _tf(_vaccineDoseCtrl, 'Dose'),
          ],

          if (_selectedActivityType?.toLowerCase() == 'weighing') ...[
            _tf(_weightCtrl, 'Weight'),
            _tf(_weightUnitCtrl, 'Unit'),
          ],

          if (_selectedActivityType?.toLowerCase() == 'breeding') ...[
            _tf(_breedingTypeCtrl, 'Breeding Type'),
            _tf(_sireTagCtrl, 'Sire Tag'),
          ],

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _isLoading
                    ? (widget.existingActivity != null
                          ? 'Updating...'
                          : 'Saving...')
                    : (widget.existingActivity != null
                          ? 'Update Activity'
                          : 'Save Activity'),
              ),
              onPressed: _isLoading ? null : _onSave,
            ),
          ),
        ],
      ),
    );
  }

  void _onSave() async {
    if (_isLoading) return; // Prevent multiple submissions

    final farm = context.read<CurrentFarm>().farm;
    final cattleList = context.read<CattleViewModel>().cattleList;
    if (farm == null ||
        _selectedCowId == null ||
        _selectedActivityType == null ||
        _dateCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Find the selected cow for cattleName
    final selectedCow = cattleList.firstWhere(
      (c) => c.id == _selectedCowId,
      orElse: () => null as dynamic, // workaround for nullable result
    );
    final cattleName = selectedCow != null
        ? '${selectedCow.tag} - ${selectedCow.name}'
        : null;

    // Create the activity object
    final activity = Activity(
      id: widget.existingActivity?.id ?? '',
      farmId: farm.id,
      cattleId: _selectedCowId!,
      cattleName: cattleName,
      type: _selectedActivityType!,
      date: _dateCtrl.text.trim(),
      farmName: farm.name,
      performedBy: _performedByCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
      diagnosis: _diagnosisCtrl.text.trim(),
      symptoms: _symptomsCtrl.text.trim().isEmpty
          ? []
          : _symptomsCtrl.text.trim().split(',').map((s) => s.trim()).toList(),
      medications: _medicationsCtrl.text.trim().isEmpty
          ? []
          : _medicationsCtrl.text
                .trim()
                .split(',')
                .map((m) => m.trim())
                .toList(),
      vaccineName: _vaccineNameCtrl.text.trim(),
      vaccineDose: _vaccineDoseCtrl.text.trim(),
      weight: _weightCtrl.text.trim(),
      weightUnit: _weightUnitCtrl.text.trim(),
      breedingType: _breedingTypeCtrl.text.trim(),
      sireTag: _sireTagCtrl.text.trim(),
      createdOn:
          widget.existingActivity?.createdOn ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );

    try {
      if (widget.existingActivity != null) {
        await _activityVm.update(activity.id, activity);
      } else {
        await _activityVm.add(activity);
      }

      if (!mounted) {
        setState(() => _isLoading = false);
        return;
      }

      // Check for errors
      if (_activityVm.error != null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save activity: ${_activityVm.error}'),
          ),
        );
        return;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingActivity != null
                ? 'Activity updated successfully!'
                : 'Activity saved successfully!',
          ),
        ),
      );

      // Clear form and close modal
      _clearForm();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        setState(() => _isLoading = false);
        return;
      }
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving activity: $e')));
    }
  }

  Widget _tf(
    TextEditingController ctrl,
    String label, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget _dropdown(
    TextEditingController ctrl,
    String label,
    List<String> options, {
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        value: ctrl.text.isEmpty ? null : ctrl.text,
        items: options
            .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
            .toList(),
        onChanged: (val) {
          if (val != null) {
            ctrl.text = val;
            onChanged(val);
          }
        },
      ),
    );
  }
}
