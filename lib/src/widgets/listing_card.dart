import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:flutter/material.dart';

import '../models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;

  ListingCard(this.listing);

  void onBidClicked() {
    if (!listing.biddingEnded) {
      // TODO: go to bid screen
    }
  }

  @override
  Widget build(BuildContext context) {
    bool biddingEnded = listing.biddingEnded;

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
                  color: ThemeColor.titleTextColor,
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
              color: biddingEnded ? ThemeColor.lightGrey : ThemeColor.lightBlue,
            ),
            child: Text(
              '${biddingEnded ? "Sold" : "Bid now"}\n${listing.finalPrice.toInt().toString()}',
              style: biddingEnded
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
        onTap: () => print("listing clicked"),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [imageStack, detailsCol],
          ),
        ));
  }
}
