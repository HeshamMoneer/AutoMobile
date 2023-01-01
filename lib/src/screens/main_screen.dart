import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/listing.dart';
import '../themes/theme_color.dart';
import '../widgets/listing_card.dart';

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
    String curUserId = allProvider.getCurrentUserId();
    List<Listing> allListings = allProvider.getAllListingsAsList();
    List<Listing> shownListings = allListings
        .where((listing) =>
            listing.biddingEnded == false && listing.userId != curUserId)
        .toList();
    shownListings.sort(
      (a, b) => a.endBidDate.compareTo(b.endBidDate),
    );
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Automobile'))
            ],
          ),
          backgroundColor: ThemeColor.lightblack,
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
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return ListingCard(shownListings[idx]);
              },
              itemCount: shownListings.length,
            )));
  }
}
