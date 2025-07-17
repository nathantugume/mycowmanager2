import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/presentation/views/analytics_screen.dart';
import 'package:mycowmanager/presentation/views/farm_setup_screen.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'activities_screen.dart';
import 'cattle_screen.dart';
import 'milk_screen.dart';
import 'finance_screen.dart';

/// Responsive mobile‑friendly dashboard.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <DashboardItem>[
      DashboardItem(
        title: 'Animals',
        imageName: 'assets/images/cow.png',
        color: Colors.white,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const CattleScreen()));
        },
      ),
      DashboardItem(
        title: 'Milk Logs',
        imageName: 'assets/images/milk.png',
        color: Colors.white,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const MilkScreen()));
        },
      ),
      DashboardItem(
        title: 'Activities',
        imageName: 'assets/images/tasks.png',
          color: Colors.white,
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ActivityScreen()));
        }
      ),
      DashboardItem(
        title: 'Finance',
        imageName: 'assets/images/business.png',
          color: Colors.white,
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const FinanceScreen()));
        }
      ),
      DashboardItem(
        title: 'Analytics',
        imageName: 'assets/images/analytics.png',
        color: Colors.white,
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const AnalyticsScreen()));        }
      ),
      DashboardItem(title: 'Manage Farm',imageName: 'assets/images/settings.png', color: Colors.white
      ,onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const FarmSetupScreen()));
          }),
 
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
        actions: [
          PopupMenuButton(
              icon: FaIcon(FontAwesomeIcons.ellipsisVertical,),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(child: ListTile(
                  title: const Text('Settings'),
                  leading: const FaIcon(FontAwesomeIcons.wrench),
                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FarmSetupScreen()));},
                ),
                ),
              PopupMenuItem(child: ListTile(
                title: const Text('Log out'),
                leading: const FaIcon(FontAwesomeIcons.signOut),
                onTap: () => context.read<AuthRepository>().signOut(),
              ),
              )
              ]
          ),

          // IconButton(
          //   icon: FaIcon(FontAwesomeIcons.ellipsisVertical,color: Colors.white,),
          //   onPressed: () => context.read<AuthRepository>().signOut(),
          //   tooltip: 'Sign out',
          // ),
        ],
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
                 padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                 child: GridView.builder(
                             itemCount: items.length,
                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: crossAxisCount,
                               mainAxisSpacing: 20,
                               crossAxisSpacing: 16,
                               childAspectRatio: 3 / 3,
                             ),
                             itemBuilder: (context, index) =>
                  DashboardCard(item: items[index]),
                           ),
               ), 
          ],);
        },
      ),
      drawer: Drawer(),

    );
  }
}

extension on Type {
  void operator [](PopupMenuItem other) {}
}

/// Reusable model for each dashboard card.
class DashboardItem {
  final String title;
  final String imageName;
  final Color color;
  final VoidCallback? onTap;

  const DashboardItem({
    required this.title,
    required this.imageName,
    required this.color,
    this.onTap,
  });
}

/// Reusable card widget.
class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.item});

  final DashboardItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: item.color,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item.imageName,height: 80,width: 80,),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,

            ),
          ],
        ),
      ),
    );
  }
}
