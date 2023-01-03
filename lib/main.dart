import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/routes/route.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool staySignedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  staySignedIn = prefs.getBool('staySignedIn') ?? false;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var allProvider = AllProvider();
    return ChangeNotifierProvider(
      create: (ctx) => allProvider,
      child: MaterialApp(
        title: 'AutoMobile',
        theme: AppTheme.lightTheme,
        initialRoute: allProvider.getCurrentUserId() == "" || !staySignedIn
            ? '/'
            : '/mainscreen',
        routes: Routes.getRoutes(),
      ),
    );
  }
}
