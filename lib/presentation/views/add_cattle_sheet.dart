import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/breed/breed.dart';
import '../../models/cattle/cattle.dart';
import '../../models/cattle_group/cattle_group.dart';
import '../../models/sources/source.dart';
import '../viewmodels/breed_view_model.dart';
import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/cattle_group_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import '../viewmodels/sources_view_model.dart';

class AddCattleSheet extends StatefulWidget {
  final Cattle? existingCattle;

  const AddCattleSheet({super.key, this.existingCattle});

  @override
  State<AddCattleSheet> createState() => _AddCattleSheetState();
}

class _AddCattleSheetState extends State<AddCattleSheet> {
  // ───────────────────────────────────────── controllers & state
  final _nameCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _dobCtrl = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  late FarmViewModel _farmVm;
  bool _hasRetried = false;
  Timer? _retryTimer;

  String? _selectedBreed;
  String? _selectedGender;
  Cattle? _selectedFather;
  Cattle? _selectedMother;
  Source? _selectedSource;

  CattleGroup? _selectedGroup;
  DateTime _startTime = DateTime.now();

  bool _groupsRequested = false; // avoid duplicate fetches
  String? _tagError;
  String? _nameError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tagCtrl.dispose();
    _weightCtrl.dispose();
    _dobCtrl.dispose();
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _farmVm = context.read<FarmViewModel>();
    _startRetryWatcher();

    final cattle = widget.existingCattle;
    if (cattle != null) {
      _nameCtrl.text = cattle.name;
      _tagCtrl.text = cattle.tag;
      _weightCtrl.text = cattle.weight.toString();
      _dobCtrl.text = cattle.dob;
      _selectedBreed = cattle.breed;
      _selectedGender = cattle.gender;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preselectDropdowns();
    });
    _tagCtrl.addListener(_validateTag);
    _nameCtrl.addListener(_validateName);
  }

  void _startRetryWatcher() {
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime);

      if (!_hasRetried && elapsed > const Duration(seconds: 8)) {
        _hasRetried = true;
        _farmVm.loadForCurrentUser(); // 🔄 RETRY
        debugPrint("⏱ Retrying loadForCurrentUser...");
      }
    });
  }

  void _validateTag() {
    final tag = _tagCtrl.text.trim();
    final cattleList = context.read<CattleViewModel>().cattleList;
    final isDuplicate = cattleList.any(
      (c) =>
          c.tag.toLowerCase() == tag.toLowerCase() &&
          c.status.toLowerCase() == 'active' &&
          (widget.existingCattle == null || c.id != widget.existingCattle!.id),
    );
    setState(() {
      _tagError = isDuplicate && tag.isNotEmpty
          ? 'This tag is already in use by an active cow.'
          : null;
    });
  }

  void _validateName() {
    final name = _nameCtrl.text.trim();
    final cattleList = context.read<CattleViewModel>().cattleList;
    final isDuplicate = cattleList.any(
      (c) =>
          c.name.toLowerCase() == name.toLowerCase() &&
          c.status.toLowerCase() == 'active' &&
          (widget.existingCattle == null || c.id != widget.existingCattle!.id),
    );
    setState(() {
      _nameError = isDuplicate && name.isNotEmpty
          ? 'This name is already in use by an active cow.'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Current farm comes from a holder ViewModel
    final currentFarm = context.watch<CurrentFarm>().farm; // nullable Farm?
    // Groups ViewModel
    final groupVm = context.watch<CattleGroupViewModel>();
    final breedVm = context.watch<BreedViewModel>();
    final cattleList = context.watch<CattleViewModel>().cattleList;
    final maleCattle = cattleList.where((c) => c.gender == 'Male').toList();
    final femaleCattle = cattleList.where((c) => c.gender == 'Female').toList();
    final sourceVm = context.watch<SourcesViewModel>();
    final sources = sourceVm.sourcesList;
    final isEditing = widget.existingCattle != null;
    final isLoading = context.watch<CattleViewModel>().isLoading;
    final operationalStatus = context.watch<CattleViewModel>().operationStatus;

    // Show a loader until farm is ready
    if (currentFarm == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // fetch groups once when we have a farm selected
    if (!_groupsRequested) {
      _groupsRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        groupVm.getByFarmId(currentFarm.id);
        breedVm.getByFarmId(currentFarm.id);
        sourceVm.getByFarmId(currentFarm.id);
      });
    }

    final groups = groupVm.cattleList;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  //close
                  Navigator.pop(context);
                },
                child: Text("X", style: TextStyle(fontSize: 18)),
              ),
            ),
            Text('Add New Cow', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            _tf(_nameCtrl, 'Name'),
            if (_nameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  _nameError!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 10),
            _tf(_tagCtrl, 'Tag / Ear‑tag'),
            if (_tagError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  _tagError!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 10),

            // Gender dropdown
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Male', child: Text('Male')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
              ),
              onChanged: (v) => setState(() => _selectedGender = v),
            ),
            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _selectedBreed,
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ...breedVm.breedList.map(
                  (b) => DropdownMenuItem(value: b.name, child: Text(b.name)),
                ),
                const DropdownMenuItem(
                  value: '__add__',
                  child: Text('➕ Add new breed'),
                ),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Breed',
              ),
              onChanged: (value) async {
                if (value == '__add__') {
                  final newName = await _showAddDialog(context, 'Breed');
                  if (newName != null && newName.isNotEmpty) {
                    final newBreed = Breed(
                      id: '', // let backend generate ID if needed
                      farmId: currentFarm.id,
                      name: newName.trim(),
                      createdOn: DateFormat(
                        'dd-MM-yyyy HH:mm:ss',
                      ).format(DateTime.now()),
                      updatedOn: DateFormat(
                        'dd-MM-yyyy HH:mm:ss',
                      ).format(DateTime.now()),
                      farmName: currentFarm.name,
                    );
                    await breedVm.add(newBreed);
                    setState(() => _selectedBreed = newName);
                  }
                } else {
                  setState(() => _selectedBreed = value);
                }
              },
            ),
            SizedBox(height: 10),

            DropdownButtonFormField<Source?>(
              value: _selectedSource,
              items: [
                const DropdownMenuItem<Source?>(
                  value: null,
                  child: Text('None'),
                ),
                ...sources.map(
                  (s) => DropdownMenuItem(value: s, child: Text(s.name)),
                ),
                const DropdownMenuItem<Source?>(
                  value: Source(
                    id: '__add__',
                    name: '➕ Add new source',
                    farmId: '',
                  ),
                  child: Text('➕ Add new source'),
                ),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Source of Cattle',
              ),
              onChanged: (value) async {
                if (value?.id == '__add__') {
                  final newName = await _showAddDialog(context, 'Source');
                  if (newName != null && newName.isNotEmpty) {
                    final newSource = Source(
                      id: '',
                      name: newName.trim(),
                      farmId: currentFarm.id,
                      createdAt: DateFormat(
                        'yyyy-MM-dd HH:mm:ss',
                      ).format(DateTime.now()),
                    );
                    await sourceVm.add(newSource);
                    await sourceVm.getByFarmId(currentFarm.id); // refresh list

                    setState(() {
                      _selectedSource = sourceVm.sourcesList.firstWhere(
                        (s) =>
                            s.name.toLowerCase() ==
                            newSource.name.toLowerCase(),
                        // orElse: () => '',
                      );
                    });
                  }
                } else {
                  setState(() => _selectedSource = value);
                }
              },
            ),
            SizedBox(height: 10),

            // Group dropdown or add button
            ...[
              DropdownButtonFormField<CattleGroup?>(
                value: _selectedGroup,
                items: [
                  const DropdownMenuItem<CattleGroup?>(
                    value: null,
                    child: Text('None'),
                  ),
                  ...groups.map(
                    (g) => DropdownMenuItem(value: g, child: Text(g.name)),
                  ),
                  const DropdownMenuItem<CattleGroup?>(
                    value: CattleGroup(
                      id: '__add__',
                      name: '➕ Add new group',
                      farmId: '',
                      farmName: '',
                      createdOn: '',
                      updatedOn: '',
                    ),
                    child: Text('➕ Add new group'),
                  ),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group',
                ),
                onChanged: (v) async {
                  // Handle "Add new group"
                  if (v?.id == '__add__') {
                    final newName = await _showAddDialog(context, 'Group');
                    if (newName != null && newName.trim().isNotEmpty) {
                      final newGroup = CattleGroup(
                        id: '',
                        farmId: currentFarm.id,
                        farmName: currentFarm.name,
                        name: newName.trim(),
                        createdOn: DateFormat(
                          'dd-MM-yyyy HH:mm:ss',
                        ).format(DateTime.now()),
                        updatedOn: DateFormat(
                          'dd-MM-yyyy HH:mm:ss',
                        ).format(DateTime.now()),
                      );
                      await groupVm.add(newGroup);
                      setState(() => _selectedGroup = newGroup);
                    }
                  } else {
                    setState(() => _selectedGroup = v);
                  }
                },
              ),
            ],
            SizedBox(height: 10),
            DropdownButtonFormField<Cattle>(
              value: _selectedFather,
              items: maleCattle
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text("${c.tag}-${c.name}"),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Father (Tag)',
              ),
              onChanged: (cattle) => setState(() => _selectedFather = cattle),
            ),
            SizedBox(height: 10),

            DropdownButtonFormField<Cattle>(
              value: _selectedMother,
              items: femaleCattle
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text("${c.tag} - ${c.name}"),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mother (Tag)',
              ),
              onChanged: (cattle) => setState(() => _selectedMother = cattle),
            ),
            SizedBox(height: 10),

            // Date picker
            TextField(
              controller: _dobCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of Birth',
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  _dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
            SizedBox(height: 10),
            _tf(_weightCtrl, 'Weight (kg)', keyboardType: TextInputType.number),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(isLoading ? 'Saving...' : 'Save'),
                onPressed: isLoading || _tagError != null || _nameError != null
                    ? null
                    : () async {
                        if (!_validate(context, farm: currentFarm)) return;

                        final cattle = Cattle(
                          id: widget.existingCattle?.id ?? '',
                          farmId: currentFarm.id,
                          farmName: currentFarm.name,
                          name: _nameCtrl.text.trim(),
                          breed: _selectedBreed!,
                          tag: _tagCtrl.text.trim(),
                          dob: _dobCtrl.text.trim(),
                          gender: _selectedGender!,
                          cattleGroup: _selectedGroup!.id,
                          source: _selectedSource!.name,
                          createdOn:
                              widget.existingCattle?.createdOn ??
                              DateFormat(
                                'dd-MM-yyyy HH:mm:ss',
                              ).format(DateTime.now()),
                          updatedOn: DateFormat(
                            'dd-MM-yyyy HH:mm:ss',
                          ).format(DateTime.now()),
                          status: 'active',
                          fatherTag: _selectedFather?.tag,
                          motherTag: _selectedMother?.tag,
                          weight: _weightCtrl.text.trim(),
                        );

                        final cattleVm = context.read<CattleViewModel>();
                        if (widget.existingCattle != null) {
                          await cattleVm.update(cattle.id, cattle);
                        } else {
                          await cattleVm.add(cattle);
                        }

                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────── helpers
  TextField _tf(
    TextEditingController c,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }

  bool _validate(BuildContext ctx, {required dynamic farm}) {
    if (farm == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please select a farm first')),
      );
      return false;
    }

    if (_nameCtrl.text.trim().isEmpty ||
        _tagCtrl.text.trim().isEmpty ||
        _selectedGender == null ||
        _selectedBreed == null ||
        _dobCtrl.text.isEmpty ||
        _selectedGroup == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  void _preselectDropdowns() {
    final cattle = widget.existingCattle;
    if (cattle == null) return;

    final groupVm = context.read<CattleGroupViewModel>();
    final sourceVm = context.read<SourcesViewModel>();
    final breedVm = context.read<BreedViewModel>();
    final cattleVm = context.read<CattleViewModel>();

    final allGroups = groupVm.cattleList;
    final allSources = sourceVm.sourcesList;
    final allCattle = cattleVm.cattleList;
    final allBreed = breedVm.breedList;

    setState(() {
      _selectedGroup = allGroups.any((g) => g.id == cattle.cattleGroup)
          ? allGroups.firstWhere((g) => g.id == cattle.cattleGroup)
          : null;
      _selectedBreed =
          allBreed.any(
            (b) => b.name.toLowerCase() == cattle.breed.toLowerCase(),
          )
          ? allBreed
                .firstWhere(
                  (b) => b.name.toLowerCase() == cattle.breed.toLowerCase(),
                )
                .name
          : null;

      _selectedSource =
          allSources.any(
            (s) => s.name.toLowerCase() == cattle.source.toLowerCase(),
          )
          ? allSources.firstWhere(
              (s) => s.name.toLowerCase() == cattle.source.toLowerCase(),
            )
          : null;

      _selectedFather =
          cattle.fatherTag != null &&
              allCattle.any((c) => c.tag == cattle.fatherTag)
          ? allCattle.firstWhere((c) => c.tag == cattle.fatherTag)
          : null;

      _selectedMother =
          cattle.motherTag != null &&
              allCattle.any((c) => c.tag == cattle.motherTag)
          ? allCattle.firstWhere((c) => c.tag == cattle.motherTag)
          : null;
    });
  }
}

Future<String?> _showAddDialog(BuildContext context, String label) async {
  final ctrl = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('New $label'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: '$label name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size(100, 40)),
          ),
          onPressed: () {
            final value = ctrl.text.trim();
            if (value.isEmpty) return;
            Navigator.pop(ctx, value);
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
