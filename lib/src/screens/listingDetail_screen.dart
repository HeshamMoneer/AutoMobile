import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:intl/intl.dart';
import '';

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
    //Query poster from ID
    final posterUser = User(
        id: "1",
        firstName: "Ahmed",
        lastName: "Atwan",
        email: "a@leh.com",
        phoneNumber: "01010",
        joiningDate: DateTime.now().toString(),
        isMale: true);
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
            margin: EdgeInsets.only(bottom: 2),
            height: 150,
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
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Color(0xFF0079b2),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            elevation: 25,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 85,
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later,
                              color: Colors.black,
                            ),
                            Text(listing.biddingDurationInWords,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 15),
                                softWrap: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(listing.title,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      softWrap: true),
                  listing.bids.length == 0
                      ? Text("Be the first to bid",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(229, 214, 214, 214)))
                      : Text("Total bids: ${listing.bids.length}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(229, 214, 214, 214))),
                  Divider(
                    color: Color.fromARGB(177, 255, 255, 255),
                  ),
                  Row(
                    children: [
                      Card(
                          margin: EdgeInsets.only(right: 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: Image.network(posterUser.profilePicPath,
                                    height: 40, width: 40, fit: BoxFit.cover),
                              ),
                            ],
                          )),
                      Text(
                        posterUser.firstName + " " + posterUser.lastName,
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text("starting:"),
                  //     Icon(Icons.monetization_on_rounded),
                  //     Text(listing.initialPrice.toString())
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text(listing.description,
                  style: TextStyle(fontSize: 20), softWrap: true)),
          Container(
            margin: EdgeInsets.all(10),
            color: Color.fromARGB(227, 131, 213, 236),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Biddings:", style: AppTheme.h3Style)),
                Container(
                    height: 170,
                    child: listing.bids.isEmpty
                        ? Align(
                            alignment: Alignment.center,
                            child: Text("No biddings yet!"))
                        : ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Card(
                                child: ListTile(
                                  leading: Text(
                                    listing
                                        .bids[listing.bids.length - index - 1]
                                        .price
                                        .toString(),
                                    style: TextStyle(
                                        color: index == 0
                                            ? Colors.green
                                            : Colors.grey,
                                        fontSize: 20),
                                  ),
                                  title: InkWell(
                                    onTap: () {
                                      //go to user page
                                    },
                                    child: Text(
                                      posterUser.firstName +
                                          " " +
                                          posterUser.lastName,
                                    ),
                                  ),
                                  subtitle: Text(DateFormat('dd-MM-yyyy')
                                      .format(listing
                                          .bids[listing.bids.length - index - 1]
                                          .creationDate)),
                                  trailing: IconButton(
                                      onPressed: () {
                                        //TODO: Add messaging
                                        //message action
                                      },
                                      icon: Icon(Icons.message)),
                                ),
                              );
                            },
                            itemCount: listing.bids.length,
                          )),
              ],
            ),
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Text("Next Bid"),
                Text(listing.newBidPrice.toString(),
                    style: TextStyle(fontSize: 20))
              ]),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: onBidClicked,
                child: const Text('Bid Now!'),
              )
            ],
          ))
        ],
      ),
    );
  }
}
