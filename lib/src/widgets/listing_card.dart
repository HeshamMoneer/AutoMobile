import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:AutoMobile/src/widgets/dialogs.dart';
import 'package:AutoMobile/src/widgets/make_bidding.dart';
import 'package:flutter/material.dart';
import 'package:AutoMobile/src/provider/provider.dart';
import 'package:provider/provider.dart';

import '../models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;

  ListingCard(this.listing);

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: true);
    bool isOwner = allProvider.getCurrentUserId() == listing.userId;
    bool biddingEnded = listing.biddingEnded;

    void onBidClicked() {
      if (!biddingEnded && !isOwner) {
        showBidBottomSheet(context, listing);
      }
    }

    void onDeleteListing() async {
      Navigator.of(context).pop();
      try {
        showLoadingDialog(context);
        await allProvider.deleteListing(listing);
        Navigator.of(context).pop();
      } catch (e) {
        showErrorDialog(context);
      }
    }

    final deleteButton = isOwner
        ? SizedBox(
            width: 80,
            child: IconButton(
              onPressed: () {
                showConfirmationDialog(
                    context: context, onConfirm: onDeleteListing);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              // alignment: Alignment.bottomRight,
              iconSize: 32,
            ))
        : Container();

    final imageOverlay =
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(5),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_filled,
                  color: ThemeColor.lightblack,
                ),
                Text(
                  listing.biddingDurationInWords,
                  style: AppTheme.titleStyle,
                )
              ],
            )),
      )
    ]);
    final imageStack = Card(
        margin: EdgeInsets.only(right: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Image.network(listing.imagesOrDefault[0],
                  height: 120, width: 170, fit: BoxFit.cover),
            ),
            Positioned.fill(child: Center(child: imageOverlay)),
          ],
        ));

    int nBids = listing.bids.length;
    String bidButtonText =
        '${biddingEnded ? (nBids == 0 ? "Not sold" : "Sold") : "Bid now"}';
    String bidButtonPrice = biddingEnded
        ? listing.finalPrice.toInt().toString()
        : listing.newBidPrice.toString();
    bool bidButtonDimmed = biddingEnded;
    if (isOwner) {
      bidButtonText =
          '${biddingEnded ? (nBids == 0 ? "Not sold" : "Sold") : "${(nBids == 0 ? "No" : nBids)} Bid${nBids == 1 ? "" : "s"}"}';
      bidButtonPrice = listing.finalPrice.toInt().toString();
    }

    final bidNowButton = Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
          onTap: onBidClicked,
          child: Ink(
              padding: EdgeInsets.all(10),
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: bidButtonDimmed
                    ? ThemeColor.lightGrey
                    : ThemeColor.darkgrey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bidButtonText,
                    style: bidButtonDimmed
                        ? AppTheme.bidButtonInactiveTextStyle
                        : AppTheme.bidButtonTextStyle,
                  ),
                  Text(
                    bidButtonPrice,
                    style: bidButtonDimmed
                        ? AppTheme.bidButtonInactiveTextStyle
                        : AppTheme.bidButtonTextStyle,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                ],
              ))),
    );

    final detailsCol = Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listing.title,
          style: AppTheme.titleStyle,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [bidNowButton, deleteButton],
        )
      ],
    ));

    return InkWell(
        onTap: () => goToListingDetailsPage(context, listing),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [imageStack, detailsCol],
          ),
        ));
  }
}

void goToListingDetailsPage(BuildContext myContext, Listing listing) {
  Navigator.of(myContext)
      .pushNamed('/listingDetail', arguments: {'listing': listing});
}
