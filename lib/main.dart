import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycowmanager/presentation/viewmodels/activities_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/breed_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/cattle_group_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/cattle_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/farm_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/income_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/milk_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/sources_view_model.dart';
import 'package:mycowmanager/presentation/viewmodels/user_view_model.dart';
import 'package:mycowmanager/presentation/views/dashboard_screen.dart';
import 'package:mycowmanager/presentation/views/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/viewmodels/login_view_model.dart';
import 'presentation/viewmodels/register_view_model.dart';
import 'presentation/viewmodels/expense_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().catchError((e) {
    if (e.toString().contains('already exists')) return Firebase.app();
    throw e;
  });
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => IncomeViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
        ChangeNotifierProvider(create: (_) => ActivitiesViewModel()),
        ChangeNotifierProvider(create: (_) => MilkViewModel()),
        ChangeNotifierProvider(create: (_) => SourcesViewModel()),
        ChangeNotifierProvider(create: (_) => BreedViewModel()),
        ChangeNotifierProvider(create: (_) => CattleGroupViewModel()),
        ChangeNotifierProvider(create: (_) => CattleViewModel()..getAll()),
        //global current farm holder
        ChangeNotifierProvider(create: (_) => CurrentFarm()),
        // Repository
        ChangeNotifierProvider(
          create: (ctx) =>
              FarmViewModel(ctx.read<CurrentFarm>())..loadForCurrentUser(),
        ),
        Provider(create: (context) => AuthRepository()),
        // ViewModels (ChangeNotifier)
        ChangeNotifierProxyProvider<AuthRepository, LoginViewModel>(
          create: (context) => LoginViewModel(context.read<AuthRepository>()),
          update: (_, repo, vm) {
            vm?.update(repo);
            return vm!;
          },
        ),
        ChangeNotifierProxyProvider<AuthRepository, RegisterViewModel>(
          create: (context) =>
              RegisterViewModel(context.read<AuthRepository>()),
          update: (context, repo, vm) {
            vm?.update(repo);
            return vm!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const seed = Colors.blueAccent;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Cow Monitor Loaded',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.greenAccent,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          splashColor: Colors.greenAccent,
          extendedTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Consumer<AuthRepository>(
        builder: (_, repo, _) {
          return StreamBuilder<User?>(
            stream: repo.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return const DashboardScreen();
              }
              if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: Center(
                    child: Text('An error occurred: ${snapshot.error}'),
                  ),
                );
              }
              return const WelcomeScreen();
            },
          );
        },
      ),
    );
  }
}
