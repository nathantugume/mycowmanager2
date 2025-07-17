import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/cattle_view_model.dart';
import '../viewmodels/activities_view_model.dart';
import '../viewmodels/farm_view_model.dart';

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
    final currentFarm = context.watch<CurrentFarm>().farm;
    if (kDebugMode) {
      print('CattleScreen build: currentFarm=$currentFarm');
    }
    if (currentFarm == null) {
      if (kDebugMode) {
        print('Current farm is null, showing loader');
      }
      return const Center(child: CircularProgressIndicator());
    }
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
                builder: (context, vm, _) {
                  print('Cattle list length: ${vm.cattleList.length}');
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
