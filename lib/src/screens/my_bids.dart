import 'package:AutoMobile/src/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/bid.dart';
import '../models/listing.dart';
import '../widgets/dialogs.dart';
import '../widgets/listing_card.dart';

class MyBidsScreen extends StatefulWidget {
  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {
  @override
  void initState() {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    // should be false to be called from initstate
    allProvider.fetchListings();
    allProvider.fetchBids();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: true);
    String curUserId = allProvider.getCurrentUserId();
    Map<String, Listing> allListings = allProvider.getAllListings;
    List<Bid> allBids = allProvider.getAllBids.values.toList();
    List<Bid> shownBids =
        allBids.where((bid) => bid.userId == curUserId).toList();
    shownBids.sort((a, b) => b.creationDate.compareTo(a.creationDate));

    void onBidDelete(Bid bid) async {
      Navigator.of(context).pop();
      try {
        showLoadingDialog(context);
        await allProvider.deleteBid(bid);
        Navigator.of(context).pop();
      } catch (e) {
        showErrorDialog(context);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('My Bids'),
        ),
        body: RefreshIndicator(
            onRefresh: () => Future.wait(
                [allProvider.fetchListings(), allProvider.fetchBids()]),
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                Bid bid = shownBids[idx];
                Listing listing = allListings[bid.listingId]!;
                bool isLastBid = listing.bids.last.id == bid.id;
                return Card(
                child: ListTile(
                  onTap: () => goToListingDetailsPage(context, listing),
                  tileColor: Colors.white,
                  leading: Image.network(
                    listing.imagesOrDefault[0],
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(
                    bid.price.toInt().toString(),
                    style: TextStyle(
                        color: isLastBid ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(DateFormat('dd/MM/yyyy hh:mm a')
                      .format(bid.creationDate)),
                  trailing: IconButton(
                      onPressed: () => showConfirmationDialog(
                          context: context, onConfirm: () => onBidDelete(bid)),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      )),
                ));
              },
              itemCount: shownBids.length,
            )));
  }
}
