import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/breed/breed.dart';
import '../viewmodels/breed_view_model.dart';

class AddBreedSheet extends StatefulWidget {
  final Breed? existingBreed;
  const AddBreedSheet({super.key, this.existingBreed});

  @override
  State<AddBreedSheet> createState() => _AddBreedSheetState();
}

class _AddBreedSheetState extends State<AddBreedSheet> {
  final _nameCtrl = TextEditingController();
  Timer? _retryTimer;
  bool _hasRetried = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingBreed != null) {
      _nameCtrl.text = widget.existingBreed!.name;
    }
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
        const SnackBar(content: Text('Please enter a breed name')),
      );
      return;
    }
    final vm = context.read<BreedViewModel>();
    final now = DateTime.now();
    final breed = Breed(
      id: widget.existingBreed?.id ?? '', // Use existing ID for edit
      farmId: farm.id,
      name: _nameCtrl.text.trim(),
      createdOn: widget.existingBreed?.createdOn ?? now.toIso8601String(),
      updatedOn: now.toIso8601String(),
      farmName: farm.name,
    );
    if (widget.existingBreed != null) {
      await vm.update(breed.id, breed);
    } else {
      await vm.add(breed);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final farm = context.watch<CurrentFarm>().farm;
    return Consumer<BreedViewModel>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vm.operationStatus != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(vm.operationStatus!)));
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
              Text(
                widget.existingBreed != null ? 'Edit Breed' : 'Add New Breed',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Breed Name'),
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
                label: Text(widget.existingBreed != null ? 'Update' : 'Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
