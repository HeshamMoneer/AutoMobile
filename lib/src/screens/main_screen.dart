import 'package:AutoMobile/src/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("AutoMobile"),
        actions: [
          IconButton(
              onPressed: () {
                allProvider.repository.fireBaseHandler.signout();
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Text("Hello World!!"),
    );
  }
}
