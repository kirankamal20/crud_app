import 'package:crud_app/features/home/presentation/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amberAccent),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amberAccent),
        cardTheme: const CardTheme(color: Colors.white),
      ),
      home: const HomeView(),
    );
  }
}
