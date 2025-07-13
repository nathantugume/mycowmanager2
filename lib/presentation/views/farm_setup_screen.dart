import 'package:flutter/material.dart';

import 'breed_screen.dart';
import 'cattle_group_screen.dart';
import 'dashboard_screen.dart';
import 'farm_screen.dart';

class FarmSetupScreen extends StatelessWidget{
  const FarmSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <DashboardItem>[
      DashboardItem(
        title: 'Farm',
        imageName: 'assets/images/farm.png',
        color: Colors.white,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FarmsOverviewScreen()),
          );
        },
      ),
      DashboardItem(
        title: 'Employees',
        imageName: 'assets/images/users.jpeg',
        color: Colors.white,
        onTap: () {
        },
      ),
      DashboardItem(
          title: 'Cattle Breed',
          imageName: 'assets/images/breed.png',
          color: Colors.white,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BreedScreen()));
          }
      ),
      DashboardItem(
          title: 'Cattle Groups',
          imageName: 'assets/images/cow.png',
          color: Colors.white,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CattleGroupScreen()));
          }
      ),


    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
    ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 2 / 2.5,),
                itemBuilder: (context, index) =>
                    DashboardCard(item: items[index]),
            ),
          );


        }


      ),
    );

  }
}