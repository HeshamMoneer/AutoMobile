import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/screens/search.dart';
import 'package:AutoMobile/src/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/listing.dart';
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
              addLogo(32, false),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Automobile'))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: MySearchDelegate(allListings));
                },
                icon: Icon(Icons.search)),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: allProvider.fetchListings,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return ListingCard(
                  shownListings[idx],
                );
              },
              itemCount: shownListings.length,
            )));
  }
}
