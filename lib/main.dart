import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/routes/route.dart';
import 'package:provider/provider.dart';
import 'package:AutoMobile/src/database/firebasehandler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FireBaseHandler fh = FireBaseHandler();

  void initState() {
    fh.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AllProvider(),
      child: MaterialApp(
        title: 'AutoMobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: Routes.getRoutes(),
      ),
    );
  }
}
