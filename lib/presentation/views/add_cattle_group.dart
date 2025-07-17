import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cattle_group/cattle_group.dart';
import '../viewmodels/cattle_group_view_model.dart';
import '../viewmodels/farm_view_model.dart';

class AddGroupSheet extends StatefulWidget {
  const AddGroupSheet({super.key});

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
    _startTime = DateTime.now();
    _startRetryWatcher();
  }

  void _startRetryWatcher() {
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final farm = context.read<CurrentFarm>().farm;
      if (!_hasRetried && farm == null && elapsed > const Duration(seconds: 8)) {
        _hasRetried = true;
        context.read<FarmViewModel>().loadForCurrentUser();
        debugPrint("⏱ Retrying loadForCurrentUser for group sheet...");
      }
      if (elapsed > const Duration(seconds: 15)) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _retryTimer?.cancel();
    super.dispose();
  }

  void _save() async {
    final farm = context.read<CurrentFarm>().farm;
    if (farm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a farm first')),
      );
      return;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }
    final vm = context.read<CattleGroupViewModel>();
    final now = DateTime.now();
    final group = CattleGroup(
      id: '',
      name: _nameCtrl.text.trim(),
      farmId: farm.id,
      farmName: farm.name,
      createdOn: now.toIso8601String(),
      updatedOn: now.toIso8601String(),
    );
    await vm.add(group);
    if (!mounted) return;
    // Feedback and close handled in Consumer below
  }

  @override
  Widget build(BuildContext context) {
    final farm = context.watch<CurrentFarm>().farm;
    return Consumer<CattleGroupViewModel>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vm.operationStatus != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(vm.operationStatus!)),
            );
            if (vm.operationStatus!.contains('successfully')) {
              Navigator.of(context).maybePop();
            }
            vm.clearStatus();
          }
        });
        if (farm == null) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add New Group', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: vm.isLoading ? null : _save,
                icon: vm.isLoading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
