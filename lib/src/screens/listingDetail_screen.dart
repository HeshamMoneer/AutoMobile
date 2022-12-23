import 'package:AutoMobile/src/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:intl/intl.dart';

import '../themes/theme.dart';

class ListingDetailScreen extends StatelessWidget {
  //final Listing listing = dummyListings[0];

  //ListingDetailScreen(this.listing);
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Listing>;
    final listing = routeArgs['listing'];
    return Scaffold(
        appBar: AppBar(title: Text("Listings")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      listing.imageUrls[index],
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: listing!.imageUrls.length,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      color: Colors.green,
                      child: Text(listing.biddingDurationInWords,
                          textAlign: TextAlign.left,
                          style: AppTheme.h4Style,
                          softWrap: true),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: Text("by: ${listing.userId}",
                          textAlign: TextAlign.left,
                          style: AppTheme.h4Style,
                          softWrap: true),
                    ),
                  )
                ],
              ),
              Card(
                child: Column(
                  children: [
                    Text(listing.title,
                        style: AppTheme.h1Style, softWrap: true),
                    Row(
                      children: [
                        Text("starting:"),
                        Icon(Icons.monetization_on_rounded),
                        Text(listing.initialPrice.toString())
                      ],
                    )
                  ],
                ),
              ),
              Text(listing.description,
                  style: AppTheme.h2Style, softWrap: true),
              Container(
                  height: 300,
                  child: listing.bids.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: Text("No biddings yet!"))
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              title: Text(
                                listing.bids[index].price.toString(),
                                style: TextStyle(
                                  color: index == listing.bids.length - 1
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              subtitle: Text(DateFormat('dd-MM-yyyy')
                                  .format(listing.bids[index].creationDate)),
                            );
                          },
                          itemCount: listing.bids.length,
                        ))
            ],
          ),
        ));
  }
}
