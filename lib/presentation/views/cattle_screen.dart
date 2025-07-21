// cattle_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mycowmanager/models/cattle/cattle.dart';

import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/activities_view_model.dart';
import 'add_cattle_sheet.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CattleScreen extends StatefulWidget {
  const CattleScreen({super.key});

  @override
  State<CattleScreen> createState() => _CattleScreenState();
}

class _CattleScreenState extends State<CattleScreen> {
  late final CattleViewModel _vm;
  String? _filterBreed;
  String? _filterGender;
  String? _filterGroup;
  String? _filterStatus;
  String? _filterStage;
  bool _isRefreshing = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _vm = CattleViewModel();
    _vm.getAll();
  }

  void _resetFilters() {
    setState(() {
      _filterBreed = null;
      _filterGender = null;
      _filterGroup = null;
      _filterStatus = null;
      _filterStage = null;
    });
  }

  @override
  void dispose() {
    _vm.dispose(); // good hygiene
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cattle', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () async {
                setState(() {
                  _isRefreshing = true;
                  _resetFilters();
                });
                await _vm.getAll();
                if (mounted) setState(() => _isRefreshing = false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter',
              onPressed: () async {
                final vm = context.read<CattleViewModel>();
                final cattleList = vm.cattleList;
                final breeds = cattleList.map((c) => c.breed).toSet().toList();
                final genders = cattleList
                    .map((c) => c.gender)
                    .toSet()
                    .toList();
                final groups = cattleList
                    .map((c) => c.cattleGroup)
                    .toSet()
                    .toList();
                final statuses = cattleList
                    .map((c) => c.status)
                    .toSet()
                    .toList();
                final stages = [
                  'Calf',
                  'Weaner',
                  'Heifer',
                  'Cow',
                  'Bull Calf',
                  'Bull',
                ];
                String? selectedBreed = _filterBreed;
                String? selectedGender = _filterGender;
                String? selectedGroup = _filterGroup;
                String? selectedStatus = _filterStatus;
                String? selectedStage = _filterStage;
                await showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (ctx) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField<String?>(
                                  decoration: const InputDecoration(
                                    labelText: 'Breed',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedBreed,
                                  items:
                                      [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                      ] +
                                      breeds
                                          .map(
                                            (b) => DropdownMenuItem<String?>(
                                              value: b,
                                              child: Text(b),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) =>
                                      setModalState(() => selectedBreed = val),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String?>(
                                  decoration: const InputDecoration(
                                    labelText: 'Gender',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedGender,
                                  items:
                                      [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                      ] +
                                      genders
                                          .map(
                                            (g) => DropdownMenuItem<String?>(
                                              value: g,
                                              child: Text(g),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) =>
                                      setModalState(() => selectedGender = val),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String?>(
                                  decoration: const InputDecoration(
                                    labelText: 'Group',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedGroup,
                                  items:
                                      [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                      ] +
                                      groups
                                          .map(
                                            (g) => DropdownMenuItem<String?>(
                                              value: g,
                                              child: Text(g),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) =>
                                      setModalState(() => selectedGroup = val),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String?>(
                                  decoration: const InputDecoration(
                                    labelText: 'Status',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedStatus,
                                  items:
                                      [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                      ] +
                                      statuses
                                          .map(
                                            (s) => DropdownMenuItem<String?>(
                                              value: s,
                                              child: Text(s),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) =>
                                      setModalState(() => selectedStatus = val),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String?>(
                                  decoration: const InputDecoration(
                                    labelText: 'Cattle Stage',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedStage,
                                  items:
                                      [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                      ] +
                                      stages
                                          .map(
                                            (s) => DropdownMenuItem<String?>(
                                              value: s,
                                              child: Text(s),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) =>
                                      setModalState(() => selectedStage = val),
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
                                      onPressed: () {
                                        setState(() {
                                          _filterBreed = selectedBreed;
                                          _filterGender = selectedGender;
                                          _filterGroup = selectedGroup;
                                          _filterStatus = selectedStatus;
                                          _filterStage = selectedStage;
                                        });
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Apply'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export to PDF',
              onPressed: () async {
                setState(() => _isExporting = true);
                final vm = context.read<CattleViewModel>();
                final filteredList = vm.cattleList.where((cattle) {
                  final matchesBreed =
                      _filterBreed == null || cattle.breed == _filterBreed;
                  final matchesGender =
                      _filterGender == null || cattle.gender == _filterGender;
                  final matchesGroup =
                      _filterGroup == null ||
                      cattle.cattleGroup == _filterGroup;
                  final matchesStatus =
                      _filterStatus == null || cattle.status == _filterStatus;
                  final matchesStage =
                      _filterStage == null ||
                      getCattleStage(cattle.dob, cattle.gender) == _filterStage;
                  return matchesBreed &&
                      matchesGender &&
                      matchesGroup &&
                      matchesStatus &&
                      matchesStage;
                }).toList();
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Cattle List',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 16),
                          pw.Table.fromTextArray(
                            headers: [
                              'Tag',
                              'Name',
                              'Breed',
                              'Gender',
                              'Group',
                              'Status',
                              'Stage',
                            ],
                            data: filteredList
                                .map(
                                  (c) => [
                                    c.tag,
                                    c.name,
                                    c.breed,
                                    c.gender,
                                    c.cattleGroup,
                                    c.status,
                                    getCattleStage(c.dob, c.gender),
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
            Consumer<CattleViewModel>(
              builder: (context, vm, _) {
                final filteredList = vm.cattleList.where((cattle) {
                  final matchesBreed =
                      _filterBreed == null || cattle.breed == _filterBreed;
                  final matchesGender =
                      _filterGender == null || cattle.gender == _filterGender;
                  final matchesGroup =
                      _filterGroup == null ||
                      cattle.cattleGroup == _filterGroup;
                  final matchesStatus =
                      _filterStatus == null || cattle.status == _filterStatus;
                  final matchesStage =
                      _filterStage == null ||
                      getCattleStage(cattle.dob, cattle.gender) == _filterStage;
                  return matchesBreed &&
                      matchesGender &&
                      matchesGroup &&
                      matchesStatus &&
                      matchesStage;
                }).toList();
                // 1️⃣ handle error
                if (vm.error != null) {
                  return Center(child: Text('⚠️ ${vm.error}'));
                }

                // 2️⃣ loading indicator
                if (vm.cattleList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 3️⃣ show list
                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (ctx, i) {
                    final cattle = filteredList[i];
                    return CattleCard(
                      item: cattle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CattleDetailsScreen(cattleId: cattle.id),
                          ),
                        );
                      },
                      onMenuTap: () async {
                        final option = await showModalBottomSheet<String>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (_) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.visibility),
                                title: const Text('View'),
                                onTap: () => Navigator.pop(context, 'view'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () => Navigator.pop(context, 'edit'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                                onTap: () => Navigator.pop(context, 'delete'),
                              ),
                            ],
                          ),
                        );

                        // Handle selected option
                        if (!context.mounted) return;
                        switch (option) {
                          case 'view':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CattleDetailsScreen(cattleId: cattle.id),
                              ),
                            );
                            break;
                          case 'edit':
                            showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (_) =>
                                  AddCattleSheet(existingCattle: cattle),
                              context: context,
                            );
                            break;
                          case 'delete':
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Cattle'),
                                content: Text(
                                  'Are you sure you want to delete ${cattle.name}?',
                                ),
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

                            if (confirmed == true) {
                              if (!context.mounted) return;

                              context.read<CattleViewModel>().delete(cattle.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Deleted')),
                              );
                            }
                            break;
                        }
                      },
                    );
                  },
                );
              },
            ),
            if (_isRefreshing || _isExporting)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blueAccent,
          icon: const FaIcon(FontAwesomeIcons.plus),
          label: const Text('Add Cow'),
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
                child: const AddCattleSheet(),
              ),
            );

            // Reload cattle list after adding
            if (!mounted) return;
            final currentFarm = context.read<CurrentFarm>().farm;
            if (currentFarm != null) {
              _vm.getByFarmId(currentFarm.id);
            }
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
//  CARD + MODEL
// ──────────────────────────────────────────────────────────

class CattleCard extends StatelessWidget {
  final Cattle item;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const CattleCard({super.key, required this.item, this.onTap, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              getCattleIcon(item),
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _text(context, item.name, isBold: true),
                  _text(context, 'Tag: ${item.tag}'),
                  _text(context, 'Breed: ${item.breed} | ${item.gender}'),
                  _text(context, 'DOB: ${item.dob}'),
                ],
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
              onPressed: onMenuTap,
            ),
          ],
        ),
      ),
    );
  }

  Text _text(BuildContext ctx, String value, {bool isBold = false}) {
    return Text(
      value,
      style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
        fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
      ),
    );
  }
}

String getCattleIcon(Cattle item) {
  final stage = getCattleStage(item.dob, item.gender).toLowerCase();
  if (stage == 'calf') return 'assets/images/calf.png';
  if (item.gender.toLowerCase() == 'female') {
    return 'assets/images/cow.png';
  }
  if (item.gender.toLowerCase() == 'male') {
    return 'assets/images/cow_male.png';
  }
  return 'assets/images/cow.png';
}

class CattleDetailsScreen extends StatefulWidget {
  final String cattleId;
  const CattleDetailsScreen({super.key, required this.cattleId});

  @override
  State<CattleDetailsScreen> createState() => _CattleDetailsScreenState();
}

class _CattleDetailsScreenState extends State<CattleDetailsScreen> {
  late final CattleViewModel _cattleVm;
  late final ActivitiesViewModel _activityVm;

  @override
  void initState() {
    super.initState();
    _cattleVm = CattleViewModel();
    _activityVm = ActivitiesViewModel();
    _cattleVm.getById(widget.cattleId);
    _activityVm.getByCattleId(widget.cattleId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _cattleVm),
        ChangeNotifierProvider.value(value: _activityVm),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Cattle Details'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Activities'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Consumer<CattleViewModel>(
                builder: (_, vm, __) {
                  final cattle = vm.singleCattle;
                  if (cattle == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Profile image and name
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: AssetImage(
                                      getCattleIcon(cattle),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    cattle.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Tag: ${cattle.tag}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Identification Section
                            Text(
                              'Identification',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.pets),
                              title: const Text('Breed'),
                              subtitle: Text(cattle.breed),
                            ),
                            ListTile(
                              leading: const Icon(Icons.male),
                              title: const Text('Gender'),
                              subtitle: Text(cattle.gender),
                            ),
                            ListTile(
                              leading: const Icon(Icons.cake),
                              title: const Text('Date of Birth'),
                              subtitle: Text(
                                '${cattle.dob}  (Age: ${calculateAge(cattle.dob)})',
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Genetics Section
                            Text(
                              'Genetics',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.female),
                              title: const Text('Mother Tag'),
                              subtitle: Text(cattle.motherTag ?? '-'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.male),
                              title: const Text('Father Tag'),
                              subtitle: Text(cattle.fatherTag ?? '-'),
                            ),
                            const SizedBox(height: 16),
                            // Lifecycle Section
                            Text(
                              'Lifecycle',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.timeline),
                              title: const Text('Stage'),
                              subtitle: Text(
                                getCattleStage(cattle.dob, cattle.gender),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.group_work),
                              title: const Text('Group'),
                              subtitle: Text(
                                (cattle.cattleGroup ?? cattle.addGroup) ?? '',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.source),
                              title: const Text('Source'),
                              subtitle: Text(cattle.source),
                            ),
                            const SizedBox(height: 16),
                            // Physical Section
                            Text(
                              'Physical',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.monitor_weight),
                              title: const Text('Weight'),
                              subtitle: Text(cattle.weight ?? '-'),
                            ),
                            const SizedBox(height: 16),
                            // Status Section
                            Text(
                              'Status',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.info_outline),
                              title: const Text('Status'),
                              subtitle: Text(cattle.status),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Consumer<ActivitiesViewModel>(
                builder: (_, vm, __) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.activityList.isEmpty) {
                    return const Center(
                      child: Text('No activities for this cow.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: vm.activityList.length,
                    itemBuilder: (_, i) {
                      final act = vm.activityList[i];
                      return ListTile(
                        title: Text('${act.type} (${act.date})'),
                        subtitle: Text(act.notes ?? ''),
                        // Add more details as needed
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String calculateAge(String dob) {
  try {
    if (kDebugMode) {
      print('calculateAge called with dob: $dob');
    }
    final birthDate = _parseDate(dob);
    final now = DateTime.now();
    if (kDebugMode) {
      print('Parsed birthDate: $birthDate, now: $now');
    }
    final years = now.year - birthDate.year;
    final months = now.month - birthDate.month;
    final days = now.day - birthDate.day;
    int ageYears = years;
    int ageMonths = months;
    if (days < 0) ageMonths -= 1;
    if (ageMonths < 0) {
      ageYears -= 1;
      ageMonths += 12;
    }
    print('ageYears: $ageYears, ageMonths: $ageMonths');
    if (ageYears < 1) {
      print('Returning: $ageMonths month(s)');
      return '$ageMonths month(s)';
    }
    print('Returning: $ageYears year(s), $ageMonths month(s)');
    return '$ageYears year(s), $ageMonths month(s)';
  } catch (e) {
    print('Error in calculateAge: $e');
    return '-';
  }
}

String getCattleStage(String dob, String gender) {
  try {
    print('getCattleStage called with dob: $dob, gender: $gender');
    final birthDate = _parseDate(dob);
    final now = DateTime.now();
    final ageMonths =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    print('Parsed birthDate: $birthDate, now: $now, ageMonths: $ageMonths');
    if (ageMonths < 6) {
      print('Returning: Calf');
      return 'Calf';
    }
    if (ageMonths < 12) {
      print('Returning: Weaner');
      return 'Weaner';
    }
    if (gender.toLowerCase() == 'female') {
      if (ageMonths < 24) {
        print('Returning: Heifer');
        return 'Heifer';
      }
      print('Returning: Cow');
      return 'Cow';
    } else {
      if (ageMonths < 24) {
        print('Returning: Bull Calf');
        return 'Bull Calf';
      }
      print('Returning: Bull');
      return 'Bull';
    }
  } catch (e) {
    print('Error in getCattleStage: $e');
    return '-';
  }
}

DateTime _parseDate(String dob) {
  try {
    return DateTime.parse(dob);
  } catch (_) {
    final parts = dob.split('-');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    throw FormatException('Unrecognized date format: $dob');
  }
}
