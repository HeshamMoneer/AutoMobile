import 'package:AutoMobile/src/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/listing.dart';
import '../widgets/listing_card.dart';

class MyListingsScreen extends StatefulWidget {
  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
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
    List<Listing> shownListings =
        allListings.where((listing) => listing.userId == curUserId).toList();
    shownListings.sort((a, b) {
      if (a.biddingEnded != b.biddingEnded) return a.biddingEnded ? 1 : -1;
      return a.endBidDate.compareTo(b.endBidDate);
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('My Listings'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/createListing');
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ))
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
