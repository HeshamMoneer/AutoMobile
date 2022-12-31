import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/listing.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    // should be false to be called from initstate
    allProvider.fetchListings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: true);
    List<Listing> allListings = allProvider.getAllListingsAsList();
    
    return Scaffold(
        appBar: AppBar(
          title: Text("AutoMobile"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: MySearchDelegate(allListings));
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  allProvider.repository.fireBaseHandler.signout();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                icon: Icon(Icons.logout_rounded)),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: allProvider.fetchListings,
          child: Column(
            children: [
              Text("Hello World!!"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/createListing');
                  },
                  child: Text("Create Listing"))
            ],
          ),
        ));
  }
}
