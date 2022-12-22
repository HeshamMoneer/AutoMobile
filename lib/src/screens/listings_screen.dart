import 'package:AutoMobile/src/models/listing.dart';
import 'package:flutter/material.dart';

import '../widgets/listing_card.dart';

class ListingsScreen extends StatelessWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(title: Text("Listings")),
        body: ListView.builder(
          itemBuilder: (ctx, idx) {
            return ListingCard(dummyListings[idx]);
          },
          itemCount: dummyListings.length,
        ));
  }
}