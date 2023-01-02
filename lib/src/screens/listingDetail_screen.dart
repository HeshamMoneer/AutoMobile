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
      appBar: AppBar(title: Text("Listing Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.only(bottom: 2),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        listing.imageUrls[index],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  itemCount: listing!.imageUrls.length,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                  viewportFraction: 0.8,
                  scale: 0.7,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: ThemeColor.lightblack,
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
                          width: 100,
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
                        style: AppTheme.titleStyle2, softWrap: true),
                    listing.bids.length == 0
                        ? Text("Be the first to bid",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(229, 214, 214, 214)))
                        : Text("Total bids: ${listing.bids.length}",
                            style: AppTheme.subTitleStyle),
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
                                      BorderRadius.all(Radius.circular(25)),
                                  child: Image.network(
                                      posterUser.profilePicPath,
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.cover),
                                ),
                              ],
                            )),
                        Text(
                          posterUser.firstName + " " + posterUser.lastName,
                          style: AppTheme.subTitleStyle,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description: ",
                          style: AppTheme.titleStyle,
                        )),
                    Text(listing.description,
                        style: TextStyle(fontSize: 15), softWrap: true),
                  ],
                )),
            Container(
              margin: EdgeInsets.all(10),
              color: Color.fromARGB(223, 171, 171, 171).withOpacity(0.1),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Biddings:", style: AppTheme.titleStyle),
                      )),
                  Container(
                      height: 200,
                      child: listing.bids.isEmpty
                          ? Align(
                              alignment: Alignment.center,
                              child: Text(
                                "No biddings yet !",
                                style: AppTheme.titleStyle,
                              ))
                          : ListView.builder(
                              itemBuilder: (ctx, index) {
                                return Card(
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    leading: Text(
                                      listing
                                          .bids[listing.bids.length - index - 1]
                                          .price
                                          .toString(),
                                      style: TextStyle(
                                          color: index == 0
                                              ? Colors.green
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
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
                                        style: AppTheme.titleStyle,
                                      ),
                                    ),
                                    subtitle: Text(DateFormat('dd-MM-yyyy')
                                        .format(listing
                                            .bids[
                                                listing.bids.length - index - 1]
                                            .creationDate)),
                                    trailing: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              '/inbox/chat',
                                              arguments: posterUser);
                                        },
                                        icon: Icon(
                                          Icons.message,
                                          color: Colors.black,
                                        )),
                                  ),
                                );
                              },
                              itemCount: listing.bids.length,
                            )),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text("Next Bid"),
                  Text(listing.newBidPrice.toString(),
                      style: TextStyle(fontSize: 14))
                ]),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: ThemeColor.lightblack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: onBidClicked,
                  child: Text('Bid Now !', style: AppTheme.titleStyle2),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
