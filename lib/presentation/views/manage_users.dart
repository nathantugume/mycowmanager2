import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/appuser.dart';
import '../viewmodels/user_view_model.dart';
import '../viewmodels/farm_view_model.dart';
import 'dart:async';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});
  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late final UserViewModel _vm;
  Timer? _retryTimer;
  bool _hasRetried = false;
  DateTime _startTime = DateTime.now();
  String? _currentFarmId;

  @override
  void initState() {
    super.initState();
    _vm = UserViewModel();
    _startTime = DateTime.now();
    _loadUsersForCurrentFarm();
  }

  void _loadUsersForCurrentFarm() {
    final farm = context.read<CurrentFarm>().farm;
    if (farm != null) {
      _currentFarmId = farm.id;
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
        debugPrint("⏱ Retrying loadForCurrentUser for users screen...");
      }
      if (farm != null) {
        _currentFarmId = farm.id;
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

  void _showUserSheet({AppUser? user}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => UserSheet(existingUser: user, farmId: _currentFarmId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Users'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _startTime = DateTime.now();
                  _hasRetried = false;
                });
                _loadUsersForCurrentFarm();
              },
            ),
          ],
        ),
        body: Consumer<UserViewModel>(
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
            if (vm.users.isEmpty) {
              return const Center(child: Text('No users found'));
            }
            return RefreshIndicator(
              onRefresh: () async => _loadUsersForCurrentFarm(),
              child: ListView.builder(
                itemCount: vm.users.length,
                itemBuilder: (ctx, i) {
                  final user = vm.users[i];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.name ?? user.email ?? user.uid),
                    subtitle: Text(user.role),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _showUserSheet(user: user);
                        } else if (value == 'delete') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete User?'),
                              content: const Text(
                                'This action cannot be undone.',
                              ),
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
                            await vm.delete(
                              user.uid,
                              user.farmId ?? _currentFarmId ?? '',
                            );
                          }
                        }
                      },
                      itemBuilder: (ctx) => [
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
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add User'),
          icon: const Icon(Icons.person_add),
          onPressed: () => _showUserSheet(),
        ),
      ),
    );
  }
}

class UserSheet extends StatefulWidget {
  final AppUser? existingUser;
  final String? farmId;
  const UserSheet({super.key, this.existingUser, this.farmId});

  @override
  State<UserSheet> createState() => _UserSheetState();
}

class _UserSheetState extends State<UserSheet> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _customRoleCtrl = TextEditingController();
  String? _selectedRole;

  // Default roles for the dropdown
  static const List<String> _defaultRoles = [
    'Farm Owner',
    'Farm Manager',
    'Manager',
    'Veterinarian',
    'Worker',
    'Assistant',
    'Intern',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingUser != null) {
      _nameCtrl.text = widget.existingUser!.name ?? '';
      _emailCtrl.text = widget.existingUser!.email ?? '';
      _phoneCtrl.text = widget.existingUser!.phone ?? '';
      // Handle case where stored role is not in our predefined list
      final storedRole = widget.existingUser!.role;
      if (_defaultRoles.contains(storedRole)) {
        _selectedRole = storedRole;
      } else {
        // If role is not in our list, set to "Other" and populate custom role field
        _selectedRole = 'Other';
        _customRoleCtrl.text = storedRole;
      }
    } else {
      // Set default role for new users
      _selectedRole = _defaultRoles.first;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _customRoleCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    String role;
    if (_selectedRole == 'Other') {
      role = _customRoleCtrl.text.trim();
      if (role.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a custom role.')),
        );
        return;
      }
    } else {
      role = _selectedRole!;
    }
    final farmId = widget.farmId;
    if (name.isEmpty || email.isEmpty || role.isEmpty || farmId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }
    final vm = context.read<UserViewModel>();
    final user = AppUser(
      uid: widget.existingUser?.uid ?? email, // use email as uid for new
      name: name,
      email: email,
      phone: phone,
      role: role,
      farmId: farmId,
      profilePictureUrl: widget.existingUser?.profilePictureUrl,
    );
    if (widget.existingUser != null) {
      await vm.update(user.uid, user);
    } else {
      await vm.add(user);
    }
    if (!mounted) return;
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
          Text(
            widget.existingUser != null ? 'Edit User' : 'Add User',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(),
            ),
            items: _defaultRoles.map((role) {
              return DropdownMenuItem<String>(value: role, child: Text(role));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a role';
              }
              return null;
            },
          ),
          if (_selectedRole == 'Other') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customRoleCtrl,
              decoration: const InputDecoration(
                labelText: 'Custom Role',
                border: OutlineInputBorder(),
                hintText: 'Enter custom role name',
              ),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(widget.existingUser != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }
}
