// Breed_screen.dart
import 'package:flutter/material.dart';
import 'package:mycowmanager/models/breed/breed.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../viewmodels/breed_view_model.dart';
import '../viewmodels/farm_view_model.dart';

import 'dart:async';

class BreedScreen extends StatefulWidget {
  const BreedScreen({super.key});

  @override
  State<BreedScreen> createState() => _BreedScreenState();
}

class _BreedScreenState extends State<BreedScreen> {
  late final BreedViewModel _vm;
  Timer? _retryTimer;
  bool _hasRetried = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _vm = BreedViewModel();
    _startTime = DateTime.now();
    _loadBreedsForCurrentFarm();
  }

  void _loadBreedsForCurrentFarm() {
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
        debugPrint("⏱ Retrying loadForCurrentUser for breed screen...");
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
          title: Text('Manage Breed', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _startTime = DateTime.now();
                  _hasRetried = false;
                });
                _loadBreedsForCurrentFarm();
              },
            ),
          ],
        ),
        body: Consumer<BreedViewModel>(
          builder: (context, vm, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (vm.operationStatus != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(vm.operationStatus!)));
                vm.clearStatus();
              }
            });

            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.error != null) {
              return Center(child: Text('⚠️ ${vm.error}'));
            }

            if (vm.breedList.isEmpty) {
              return const Center(child: Text('No breeds found'));
            }

            return RefreshIndicator(
              onRefresh: () async => _loadBreedsForCurrentFarm(),
              child: ListView.builder(
                itemCount: vm.breedList.length,
                itemBuilder: (ctx, i) {
                  final breed = vm.breedList[i];
                  return BreedCard(
                    item: breed,
                    onTap: () {},
                    onMenuTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => AddBreedSheet(existingBreed: breed),
                      );
                    },
                    onReload: _loadBreedsForCurrentFarm,
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Breed'),
          icon: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const AddBreedSheet(),
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

class BreedCard extends StatelessWidget {
  final Breed item;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onReload; // <-- add this

  const BreedCard({
    super.key,
    required this.item,
    this.onTap,
    this.onMenuTap,
    this.onReload, // <-- add this
  });

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
                  _text(context, 'Name: ${item.name}'),
                  _text(context, 'Farm Name: ${item.farmName}'),
                  _text(context, 'Created on: ${item.createdOn}'),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  debugPrint(
                    'Edit tapped for breed: ${item.id} - ${item.name}',
                  );
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => AddBreedSheet(existingBreed: item),
                  );
                } else if (value == 'delete') {
                  debugPrint(
                    'Delete tapped for breed: ${item.id} - ${item.name}',
                  );
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Breed?'),
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
                  debugPrint('Delete dialog result: $confirm');
                  if (confirm == true) {
                    debugPrint(
                      'Calling delete on viewmodel for id: ${item.id}',
                    );
                    context.read<BreedViewModel>().delete(item.id);
                    onReload?.call(); // <-- call the reload callback
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
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(widget.existingBreed != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }
}
