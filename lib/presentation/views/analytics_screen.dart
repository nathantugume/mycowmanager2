import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mycowmanager/presentation/views/cattle_report.dart';
import 'package:mycowmanager/presentation/views/milk_report.dart';
import 'package:provider/provider.dart';

import '../viewmodels/farm_view_model.dart';
import 'dashboard_screen.dart';

class AnalyticsScreen extends  StatelessWidget{
  const AnalyticsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // inject global CurrentFarm instead of creating a new one
      create: (ctx) {
        final currentFarm = ctx.read<CurrentFarm>();
        final vm = FarmViewModel(currentFarm);
        vm.loadForCurrentUser();
        return vm;
      },
      child: _AnalyticsScreenBody(),
    );
  }



}
class _AnalyticsScreenBody extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FarmViewModel>();
    if (vm.error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('⚠️ ${vm.error}')),
      );
    }
    if(vm.isLoading){
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    final farm = vm.singleFarm;
    if (farm == null) {
      return Scaffold(
        body: Center(child: Text('No farms found')),
      );
    }

    final items = <DashboardItem>[
      DashboardItem(
        title: 'Milk Report',
        imageName: 'assets/images/milk.png',
        color: Colors.white,
        onTap: () {
          if (kDebugMode) {
            print("Empty farm $farm");
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MilkReportScreen( farmId: farm.id,)));
        },
      ),
      DashboardItem(
        title: 'Cattle Report',
        imageName: 'assets/images/cow.png',
        color: Colors.white,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CattleReportScreen()));
        },
      ),
      DashboardItem(
          title: 'Breed Report',
          imageName: 'assets/images/breed.png',
          color: Colors.white,
          onTap: (){

          }
      ),
      DashboardItem(
          title: 'Groups Report',
          imageName: 'assets/images/farm.png',
          color: Colors.white,
          onTap: (){
          }
      ),
      DashboardItem(
          title: 'Profit and Loss Report',
          imageName: 'assets/images/business.png',
          color: Colors.white,
          onTap: (){
          }
      ),
      DashboardItem(
          title: 'Activities Report',
          imageName: 'assets/images/tasks.png',
          color: Colors.white,
          onTap: (){
          }
      ),

    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Analytics', style: TextStyle(color: Colors.white)),
        centerTitle: true,

      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 2 columns on phones, 4 on wider screens
          final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
          return Stack(
            fit: StackFit.loose,
            children: [
              Container(height: 100,color: Colors.blueAccent,),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2 / 2.5,
                  ),
                  itemBuilder: (context, index) =>
                      DashboardCard(item: items[index]),
                ),
              ),
            ],);
        },
      ),


    );
  }

}