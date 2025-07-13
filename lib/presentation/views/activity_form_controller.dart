import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycowmanager/models/activities/activity.dart';
import 'package:provider/provider.dart';

import '../../models/farm/farm.dart';
import '../viewmodels/activities_view_model.dart';
import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/farm_view_model.dart';

class ActivityFormController extends StatefulWidget {
  const ActivityFormController({super.key});

  @override
  State<ActivityFormController> createState() => _ActivityFormControllerState();
}

class _ActivityFormControllerState extends State<ActivityFormController> {
  // ViewModels
  late final CattleViewModel _cattleVm;
  late final ActivitiesViewModel _activityVm;
  late final FarmViewModel _farmVm;

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
    _dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

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

          _tf(_dateCtrl, 'Date (yyyy-MM-dd)', readOnly: true, onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          }),

          _tf(_performedByCtrl, 'Performed By'),
          _tf(_notesCtrl, 'Notes'),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select Cow'),
          value: _selectedCowId,
          items: cattleList.map((cattle) {
            return DropdownMenuItem(
              value: cattle.id,
              child: Text('${cattle.tag} - ${cattle.name}'),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedCowId = val),
        ),
          SizedBox(height: 10),


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
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Activity'),
            onPressed: _onSave,
          ),
        ],
      ),
    );
  }

  void _onSave() {
    final farm = context.read<CurrentFarm>().farm;
    if (farm == null || _selectedCowId == null || _activityTypeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all required fields.'),
      ));
      return;
    }

    // Add your model and submit logic here
    Activity(
        id: '',
        farmId: farm.id,
        cattleId: _selectedCowId!,
        type: _activityTypeCtrl.text.trim(),
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
        : _medicationsCtrl.text.trim().split(',').map((m) => m.trim()).toList(),
        vaccineName: _vaccineNameCtrl.text.trim(),
        vaccineDose: _vaccineDoseCtrl.text.trim(),
        weight: _weightCtrl.text.trim(),
        weightUnit: _weightUnitCtrl.text.trim(),
        breedingType: _breedingTypeCtrl.text.trim(),
        sireTag: _sireTagCtrl.text.trim(),
        createdOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );



  }

  Widget _tf(TextEditingController ctrl, String label,
      {bool readOnly = false, VoidCallback? onTap}) {
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

  Widget _dropdown(TextEditingController ctrl, String label, List<String> options,
      {required ValueChanged<String> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        value: ctrl.text.isEmpty ? null : ctrl.text,
        items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
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
