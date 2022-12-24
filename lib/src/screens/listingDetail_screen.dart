import 'package:AutoMobile/src/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:intl/intl.dart';

import '../themes/theme.dart';
import '../themes/theme_color.dart';
import '../widgets/make_bidding.dart';

class ListingDetailScreen extends StatelessWidget {
  //final Listing listing = dummyListings[0];

  //ListingDetailScreen(this.listing);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Listing>;
    final listing = routeArgs['listing'];
    void onBidClicked() {
      if (!listing!.biddingEnded) {
        // TODO: go to bid screen
        showBidBottomSheet(context, listing);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Listings")),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
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
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(listing.title, style: AppTheme.h1Style, softWrap: true),
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
          Container(
              margin: EdgeInsets.all(8),
              child: Text(listing.description,
                  style: AppTheme.h2Style, softWrap: true)),
          Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Biddings:", style: AppTheme.h3Style)),
              Container(
                  height: 190,
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
                                      : Colors.grey,
                                ),
                              ),
                              subtitle: Text(DateFormat('dd-MM-yyyy')
                                  .format(listing.bids[index].creationDate)),
                            );
                          },
                          itemCount: listing.bids.length,
                        )),
            ],
          ),
          Container(
            child: InkWell(
                onTap: onBidClicked,
                child: Ink(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: listing.biddingEnded
                        ? ThemeColor.lightGrey
                        : ThemeColor.lightBlue,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${listing.biddingEnded ? "Sold" : "Bid now"}\n${listing.newBidPrice.toString()}',
                      style: listing.biddingEnded
                          ? AppTheme.bidButtonInactiveTextStyle
                          : AppTheme.bidButtonTextStyle,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
