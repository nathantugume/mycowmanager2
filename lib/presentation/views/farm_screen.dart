import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/farm_view_model.dart';
import '../viewmodels/file_manager_view_model.dart';
import '../../models/farm/farm.dart';

class FarmsOverviewScreen extends StatefulWidget {
  const FarmsOverviewScreen({super.key});

  @override
  State<FarmsOverviewScreen> createState() => _FarmsOverviewScreenState();
}

class _FarmsOverviewScreenState extends State<FarmsOverviewScreen> {
  late final FarmViewModel _vm;
  late final FileManagerViewModel _fm;

  @override
  void initState() {
    super.initState();
    // Use the global provider instance, not a new one!
    _vm = FarmViewModel(context.read<CurrentFarm>());
    _fm = FileManagerViewModel();
    _vm.loadForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: const _FarmDetailsBody(), // ListView that consumes farmList
    );
  }
}

class _FarmDetailsBody extends StatelessWidget {
  const _FarmDetailsBody();
  static const _placeholder = 'assets/images/default_bg.jpeg';
  // add to pubspec

  void _showEditFarmSheet(BuildContext context, Farm farm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditFarmSheet(farm: farm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmViewModel>(
      builder: (_, vm, __) {
        if (vm.error != null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('⚠️ ${vm.error}')),
          );
        }
        if (vm.isLoading || vm.singleFarm == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final f = vm.singleFarm!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220,
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'edit') {
                        _showEditFarmSheet(context, f);
                      }
                      if (v == 'delete') {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) =>
                              _ConfirmArchiveDialog(farmName: f.name),
                        );
                        if (ok == true) {
                          final updatedFarm = f.copyWith(
                            status: 'archived',
                            updatedOn: DateTime.now().toIso8601String(),
                          );
                          await vm.update(f.id, updatedFarm);
                          if (context.mounted) Navigator.pop(context);
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    f.name,
                    style: TextStyle(
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Hero(
                    tag: 'farm-img-${f.id}',
                    child: f.imageUrl == null
                        ? Image.asset(_placeholder, fit: BoxFit.cover)
                        : CachedNetworkImage(
                            imageUrl: f.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Image.asset(_placeholder, fit: BoxFit.cover),
                            errorWidget: (_, __, ___) =>
                                Image.asset(_placeholder, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),

              /*──────── Stats grid ────────*/
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _StatCard(
                      label: 'Location',
                      value: f.location,
                      icon: Icons.place,
                    ),
                    _StatCard(
                      label: 'Owner',
                      value: f.ownerName,
                      icon: Icons.person,
                    ),
                    _StatCard(
                      label: 'Status',
                      value: f.status ?? 'active',
                      icon: Icons.flag,
                    ),
                    _StatCard(
                      label: 'Created',
                      value: f.createdOn?.split('T').first ?? '—',
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              ),

              /*──────── Description & meta ─────*/
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (f.description != null && f.description!.isNotEmpty)
                        _Section(
                          title: 'Description',
                          child: Text(
                            f.description!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      _Section(
                        title: 'Metadata',
                        child: Column(
                          children: [
                            _metaRow(
                              'Updated',
                              f.updatedOn?.split('T').first ?? '—',
                            ),
                            _metaRow('ID', f.id),
                            _metaRow('Owner UID', f.owner),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              /*──────── Upload section ─────*/
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverToBoxAdapter(
                  child: const _Section(
                    title: 'Manage Images',
                    child: _ImageUploader(), // 👈 our new widget
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*─────────────────  sub‑widgets  ─────────────────*/

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
}

Widget _metaRow(String label, String value) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: Row(
    children: [
      Expanded(child: Text(label)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    ],
  ),
);

class _ImageUploader extends StatelessWidget {
  const _ImageUploader();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FileManagerViewModel(),
      child: Consumer<FileManagerViewModel>(
        builder: (ctx, vm, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (vm.preview != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  vm.preview!,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (vm.status != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  vm.status!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: vm.isLoading ? null : vm.pickAndUpload,
              icon: vm.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.cloud_upload),
              label: const Text('Upload farm image'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditFarmSheet extends StatefulWidget {
  final Farm farm;

  const EditFarmSheet({super.key, required this.farm});

  @override
  State<EditFarmSheet> createState() => _EditFarmSheetState();
}

class _EditFarmSheetState extends State<EditFarmSheet> {
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String? _selectedStatus;

  // Default status options
  static const List<String> _statusOptions = [
    'active',
    'inactive',
    'archived',
    'maintenance',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.farm.name;
    _locationCtrl.text = widget.farm.location;
    _descriptionCtrl.text = widget.farm.description ?? '';
    _selectedStatus = widget.farm.status ?? 'active';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    final name = _nameCtrl.text.trim();
    final location = _locationCtrl.text.trim();
    final description = _descriptionCtrl.text.trim();
    final status = _selectedStatus ?? 'active';

    if (name.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    final vm = context.read<FarmViewModel>();

    // Create updated farm object
    final updatedFarm = Farm(
      id: widget.farm.id,
      name: name,
      location: location,
      owner: widget.farm.owner,
      ownerName: widget.farm.ownerName,
      imageUrl: widget.farm.imageUrl,
      description: description.isEmpty ? null : description,
      createdOn: widget.farm.createdOn,
      updatedOn: DateTime.now().toIso8601String(),
      status: status,
    );

    await vm.update(widget.farm.id, updatedFarm);

    if (!mounted) return;

    // Show success message
    if (vm.operationStatus != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(vm.operationStatus!)));
      vm.clearStatus();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Edit Farm', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Farm Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _locationCtrl,
            decoration: const InputDecoration(
              labelText: 'Location *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionCtrl,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              hintText: 'Optional farm description',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: _statusOptions.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<FarmViewModel>(
                  builder: (context, vm, child) {
                    return ElevatedButton.icon(
                      onPressed: vm.isLoading ? null : _save,
                      icon: vm.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.save),
                      label: Text(vm.isLoading ? 'Saving...' : 'Save Changes'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmArchiveDialog extends StatefulWidget {
  final String farmName;
  const _ConfirmArchiveDialog({required this.farmName});

  @override
  State<_ConfirmArchiveDialog> createState() => _ConfirmArchiveDialogState();
}

class _ConfirmArchiveDialogState extends State<_ConfirmArchiveDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _matches = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkMatch);
  }

  void _checkMatch() {
    setState(() {
      _matches = _controller.text.trim() == widget.farmName;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Archive farm?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This will mark the farm as archived. You can restore it later if needed.',
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: 'Please type ',
              children: [
                TextSpan(
                  text: '"${widget.farmName}"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' to confirm.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Farm name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _matches ? () => Navigator.pop(context, true) : null,
          child: const Text('Archive', style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }
}
