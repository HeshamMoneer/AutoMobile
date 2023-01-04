import 'package:AutoMobile/src/models/user.dart';
import 'package:AutoMobile/src/screens/userProfile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/bid.dart';
import '../models/listing.dart';
import '../provider/provider.dart';
import '../themes/theme.dart';
import '../themes/theme_color.dart';
import '../widgets/make_bidding.dart';

class ListingDetailScreen extends StatefulWidget {
  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  bool isLoading = false;
  void initState() {
    fetchAll();
    super.initState();
  }

  Future<void> fetchAll() async {
    setState(() {
      isLoading = true;
    });
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    await Future.wait([allProvider.fetchListings(), allProvider.fetchUsers()]);
    setState(() {
      isLoading = false;
    });
  }

  //final Listing listing = dummyListings[0];
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(title: Text("Listing Details")),
          body: Center(
            child: new CircularProgressIndicator(
              color: Colors.black,
            ),
          ));
    }
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String listingId = routeArgs['listingId']!;
    var allProvider = Provider.of<AllProvider>(context, listen: true);
    Map<String, Listing> listings = allProvider.getAllListings;
    Map<String, User> users = allProvider.getAllUsers;
    Listing listing = listings[listingId]!;
    User listingOwner = users[listing.userId]!;

    void onBidClicked() {
      if (!listing.biddingEnded) {
        showBidBottomSheet(context, listing);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Listing Details")),
      body: RefreshIndicator(
        onRefresh: fetchAll,
        child: ListView(
          children: [
            SingleChildScrollView(
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
                              listing.imagesOrDefault[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        itemCount: listing.imagesOrDefault.length,
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
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.watch_later,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(listing.biddingDurationInWords,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
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
                                      color:
                                          Color.fromARGB(229, 214, 214, 214)))
                              : Text("Total bids: ${listing.bids.length}",
                                  style: AppTheme.subTitleStyle),
                          Divider(
                            color: Color.fromARGB(177, 255, 255, 255),
                          ),
                          GestureDetector(
                            onTap: () =>
                                goToUserProfile(context, listingOwner.id),
                            child: Row(
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          child: Image.network(
                                              listingOwner.profilePicPath,
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    )),
                                Text(
                                  listingOwner.firstName +
                                      " " +
                                      listingOwner.lastName,
                                  style: AppTheme.subTitleStyle,
                                )
                              ],
                            ),
                          ),
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
                              child:
                                  Text("Biddings:", style: AppTheme.titleStyle),
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
                                      Bid bid = listing.bids[
                                          listing.bids.length - index - 1];
                                      User bidOwner = users[bid.userId]!;
                                      return Card(
                                        child: ListTile(
                                          tileColor: Colors.white,
                                          leading: Text(
                                            bid.price.toString(),
                                            style: TextStyle(
                                                color: index == 0
                                                    ? Colors.green
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          title: InkWell(
                                            onTap: () {
                                              goToUserProfile(
                                                  context, bidOwner.id);
                                            },
                                            child: Text(
                                              bidOwner.firstName +
                                                  " " +
                                                  bidOwner.lastName,
                                              style: AppTheme.titleStyle,
                                            ),
                                          ),
                                          subtitle: Text(
                                              DateFormat('dd/MM/yyyy hh:mm a')
                                                  .format(bid.creationDate)),
                                          trailing: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    '/inbox/chat',
                                                    arguments: bidOwner);
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
          ],
        ),
      ),
    );
  }
}
