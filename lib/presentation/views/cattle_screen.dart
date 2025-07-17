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

class CattleScreen extends StatefulWidget {
  const CattleScreen({super.key});

  @override
  State<CattleScreen> createState() => _CattleScreenState();
}

class _CattleScreenState extends State<CattleScreen> {
  late final CattleViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = CattleViewModel();
    // kick off the fetch once
    _vm.getAll(); // or fetchAll() if you renamed it
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
          title: Text('Manage Cattle', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
        ),
        body: Consumer<CattleViewModel>(
          builder: (context, vm, _) {
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
              itemCount: vm.cattleList.length,
              itemBuilder: (ctx, i) {
                final cattle = vm.cattleList[i];
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
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Name: ${cattle.name}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text('Tag: ${cattle.tag}'),
                      Text('Breed: ${cattle.breed}'),
                      Text('Gender: ${cattle.gender}'),
                      Text('DOB: ${cattle.dob}'),
                      Text('Age: ${calculateAge(cattle.dob)}'),
                      Text(
                        'Stage: ${getCattleStage(cattle.dob, cattle.gender)}',
                      ),
                      Text('Weight: ${cattle.weight ?? '-'}'),
                      Text('Group: ${cattle.cattleGroup}'),
                      Text('Source: ${cattle.source}'),
                      Text('Mother Tag: ${cattle.motherTag ?? '-'}'),
                      Text('Father Tag: ${cattle.fatherTag ?? '-'}'),
                      Text('Status: ${cattle.status}'),
                      // Add more fields as needed
                    ],
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
