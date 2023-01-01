import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
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
    String bidButtonText =
        '${biddingEnded ? "Sold" : "Bid now"}\n${listing.newBidPrice.toString()}';
    int nBids = listing.bids.length;
    bool bidButtonDimmed = biddingEnded;
    if (isOwner) {
      bidButtonText =
          '${biddingEnded ? (nBids == 0 ? "Not sold" : "Sold") : (nBids == 0 ? "No Bids" : "${nBids} Bid")}\n${listing.finalPrice.toInt().toString()}';
    }

    final bidNowButton = Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
          onTap: onBidClicked,
          child: Ink(
            padding: EdgeInsets.all(10),
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color:
                  bidButtonDimmed ? ThemeColor.lightGrey : ThemeColor.darkgrey,
            ),
            child: Text(
              bidButtonText,
              style: bidButtonDimmed
                  ? AppTheme.bidButtonInactiveTextStyle
                  : AppTheme.bidButtonTextStyle,
            ),
          )),
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
        bidNowButton
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
