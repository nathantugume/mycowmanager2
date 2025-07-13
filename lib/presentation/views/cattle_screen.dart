// cattle_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mycowmanager/models/cattle/cattle.dart';

import '../viewmodels/cattle_view_model.dart';
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
        appBar: AppBar(title:  Text('Manage Cattle',style: TextStyle(color: Colors.white),),backgroundColor: Colors.blueAccent,),
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
                    // for example: Navigator.push(...)
                  },
                    onMenuTap: () async {
                      final option = await showModalBottomSheet<String>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                        // TODO: Navigate to detail page or show dialog
                          break;
                        case 'edit':
                          showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (_) => AddCattleSheet(existingCattle: cattle), context: context,
                          );
                          break;
                        case 'delete':
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Cattle'),
                              content: Text('Are you sure you want to delete ${cattle.name}?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            if (!context.mounted) return;

                            context.read<CattleViewModel>().delete(cattle.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
                          }
                          break;
                      }
                    }

                );
              },
            );
          },
        ),
       floatingActionButton:  FloatingActionButton.extended(
          backgroundColor: Colors.blueAccent,
          icon: const FaIcon(FontAwesomeIcons.plus),
          label: const Text('Add Cow'),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddCattleSheet(),   // ⬅️ new widget
            ),
          ),
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

  const CattleCard({
    super.key,
    required this.item,
    this.onTap,
    this.onMenuTap,
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
