// cattle_screen.dart
import 'package:flutter/material.dart';
import 'package:mycowmanager/models/cattle_group/cattle_group.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../viewmodels/cattle_group_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import 'dart:async';


class CattleGroupScreen extends StatefulWidget {
  const CattleGroupScreen({super.key});

  @override
  State<CattleGroupScreen> createState() => _CattleGroupScreenState();
}

class _CattleGroupScreenState extends State<CattleGroupScreen> {
  late final CattleGroupViewModel _vm;
  Timer? _retryTimer;
  bool _hasRetried = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _vm = CattleGroupViewModel();
    _startTime = DateTime.now();
    _loadGroupsForCurrentFarm();
  }

  void _loadGroupsForCurrentFarm() {
    final farm = context.read<CurrentFarm>().farm;
    if (farm != null) {
      _vm.getByFarmId(farm.id);
    } else {
      _startRetryWatcher();
    }
  }

  void _startRetryWatcher() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final farm = context.read<CurrentFarm>().farm;
      if (!_hasRetried &&
          farm == null &&
          elapsed > const Duration(seconds: 8)) {
        _hasRetried = true;
        context.read<FarmViewModel>().loadForCurrentUser();
        debugPrint("⏱ Retrying loadForCurrentUser for group screen...");
      }
      if (farm != null) {
        _vm.getByFarmId(farm.id);
        timer.cancel();
      }
      if (elapsed > const Duration(seconds: 15)) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _vm.dispose();
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Groups', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _startTime = DateTime.now();
                  _hasRetried = false;
                });
                _loadGroupsForCurrentFarm();
              },
            ),
          ],
        ),
        body: Consumer<CattleGroupViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text('⚠️ ${vm.error}'));
            }
            if (vm.cattleList.isEmpty) {
              return const Center(child: Text('No groups found'));
            }
            return RefreshIndicator(
              onRefresh: () async => _loadGroupsForCurrentFarm(),
              child: ListView.builder(
                itemCount: vm.cattleList.length,
                itemBuilder: (ctx, i) {
                  final cattle = vm.cattleList[i];
                  return CattleCard(
                    item: cattle,
                    onTap: () {},
                    onMenuTap: () {},
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Group'),
          icon: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const AddGroupSheet(),
            );
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
  final CattleGroup item;
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
              'assets/images/cow.png',
              height: 32,
              width: 32,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _text(context, item.name, isBold: true),
                  _text(context, 'Farm: ${item.farmName}'),
                  _text(context, 'Created on: ${item.createdOn} '),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => AddGroupSheet(existingGroup: item),
                  );
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Group?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    context.read<CattleGroupViewModel>().delete(item.id);
                    // Reload after delete
                    final farm = context.read<CurrentFarm>().farm;
                    if (farm != null) {
                      context.read<CattleGroupViewModel>().getByFarmId(farm.id);
                    }
                  }
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
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

// Update AddGroupSheet to accept an existingGroup argument for editing
class AddGroupSheet extends StatefulWidget {
  final CattleGroup? existingGroup;
  const AddGroupSheet({super.key, this.existingGroup});

  @override
  State<AddGroupSheet> createState() => _AddGroupSheetState();
}

class _AddGroupSheetState extends State<AddGroupSheet> {
  final _nameCtrl = TextEditingController();
  Timer? _retryTimer;
  bool _hasRetried = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingGroup != null) {
      _nameCtrl.text = widget.existingGroup!.name;
    }
    _startTime = DateTime.now();
    _startRetryWatcher();
  }

  void _startRetryWatcher() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final farm = context.read<CurrentFarm>().farm;
      if (!_hasRetried &&
          farm == null &&
          elapsed > const Duration(seconds: 8)) {
        _hasRetried = true;
        context.read<FarmViewModel>().loadForCurrentUser();
        debugPrint("⏱ Retrying loadForCurrentUser for group screen...");
      }
      if (farm != null) {
        context.read<CattleGroupViewModel>().getByFarmId(farm.id);
        timer.cancel();
      }
      if (elapsed > const Duration(seconds: 15)) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> _saveGroup() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group name cannot be empty.')),
      );
      return;
    }
    final farm = context.read<CurrentFarm>().farm;
    if (farm == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No farm selected.')));
      return;
    }
    final now = DateTime.now();
    final group = CattleGroup(
      id: widget.existingGroup?.id ?? '',
      name: name,
      farmId: farm.id,
      farmName: farm.name,
      createdOn: widget.existingGroup?.createdOn ?? now.toIso8601String(),
      updatedOn: now.toIso8601String(),
    );
    if (widget.existingGroup != null) {
      await context.read<CattleGroupViewModel>().update(group.id, group);
    } else {
      await context.read<CattleGroupViewModel>().add(group);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<CattleGroupViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.existingGroup != null ? 'Edit Group' : 'Add Group',
          ),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.check),
              onPressed: _saveGroup,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
