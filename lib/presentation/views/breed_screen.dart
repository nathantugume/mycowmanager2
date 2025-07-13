// Breed_screen.dart
import 'package:flutter/material.dart';
import 'package:mycowmanager/models/breed/breed.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../viewmodels/breed_view_model.dart';



class BreedScreen extends StatefulWidget {
  const BreedScreen({super.key});

  @override
  State<BreedScreen> createState() => _BreedScreenState();
}

class _BreedScreenState extends State<BreedScreen> {
  late final BreedViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = BreedViewModel();
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
        appBar: AppBar(title:  Text('Manage Breed',style: TextStyle(color: Colors.white),),backgroundColor: Colors.blueAccent,),
        body: Consumer<BreedViewModel>(
          builder: (context, vm, _) {
            // 1️⃣ handle error
            if (vm.error != null) {
              return Center(child: Text('⚠️ ${vm.error}'));
            }

            // 2️⃣ loading indicator
            if (vm.breedList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // 3️⃣ show list
            return ListView.builder(
              itemCount: vm.breedList.length,
              itemBuilder: (ctx, i) {
                final breed = vm.breedList[i];
                return BreedCard(
                  item: breed,
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
            label: const Text('Add Breed'),
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

class BreedCard extends StatelessWidget {
  final Breed item;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const BreedCard({
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
                  _text(context, 'Name: ${item.name}'),
                  _text(context, 'Farm Name: ${item.farmName}'),
                  _text(context, 'Created on: ${item.createdOn}'),
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
