// cattle_screen.dart
import 'package:flutter/material.dart';
import 'package:mycowmanager/models/cattle_group/cattle_group.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../viewmodels/cattle_group_view_model.dart';

class CattleGroupScreen extends StatefulWidget {
  const CattleGroupScreen({super.key});

  @override
  State<CattleGroupScreen> createState() => _CattleGroupScreenState();
}

class _CattleGroupScreenState extends State<CattleGroupScreen> {
  late final CattleGroupViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = CattleGroupViewModel();
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
        appBar: AppBar(title:  Text('Manage Groups',style: TextStyle(color: Colors.white),),backgroundColor: Colors.blueAccent,),
        body: Consumer<CattleGroupViewModel>(
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
                  onMenuTap: () {
                    // open bottom‑sheet / popup menu
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text('Add Group'),
            icon: const FaIcon(FontAwesomeIcons.plus),
            backgroundColor: Colors.blueAccent,
            onPressed: (){}),
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
                  _text(context, 'Farm: ${item.farmName}'),
                  _text(context, 'Created on: ${item.createdOn} '),

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
