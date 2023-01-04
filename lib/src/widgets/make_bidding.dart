import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:AutoMobile/src/widgets/dialogs.dart';
import 'package:AutoMobile/src/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../models/bid.dart';
import '../models/listing.dart';
import '../provider/provider.dart';
import 'package:provider/provider.dart';

class MakeBidding extends StatefulWidget {
  final Listing listing;

  MakeBidding(this.listing);

  @override
  State<MakeBidding> createState() => _MakeBiddingState();
}

class _MakeBiddingState extends State<MakeBidding> {
  int _bidAmount = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _bidAmount = widget.listing.newBidPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    int bidAmountStep = 100;
    int minBidAmount = widget.listing.newBidPrice;
    int maxBidAmount = minBidAmount + 100 * bidAmountStep;

    void makeBid() async {
      Navigator.of(context).pop();  // pop confirmation dialog
      var allProvider = Provider.of<AllProvider>(context, listen: false);
      try {
        setState(() {
          isLoading = true;
        });
        Bid bid = new Bid(
            userId: allProvider.getCurrentUserId(),
            listingId: widget.listing.id,
            id: "",
            price: _bidAmount.toDouble(),
            creationDate: DateTime.now());
        await allProvider.addBid(bid);
        Navigator.of(context).pop();  // pop bid bottomSheet
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        goToListingDetailsPage(context, bid.listingId);
      } catch (e) {
        print(e);
        showErrorDialog(context, body: e.toString());
      }
    }

    void onMakeBidding() async {
      showConfirmationDialog(context: context, onConfirm: makeBid, title: 'Confirm the bid', body: 'Do you really want to make a bid with $_bidAmount?');
    }

    return SingleChildScrollView(
        child: SizedBox(
            height: 180,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: ThemeColor.lightblack,),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: NumberPicker(
                              textStyle: TextStyle(color: Colors.black),
                              value: _bidAmount,
                              minValue: minBidAmount,
                              maxValue: maxBidAmount,
                              step: bidAmountStep,
                              itemHeight: 70,
                              haptics: true,
                              axis: Axis.horizontal,
                              onChanged: (value) =>
                                  setState(() => _bidAmount = value),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: ThemeColor.black, width: 2),
                              ),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width /
                              3, // <-- match_parent
                          height: 50,
                          child: ElevatedButton(
                              style: AppTheme.buttonStyleBlack,
                              onPressed: onMakeBidding,
                              child: Text(
                                "Make a Bid",
                              )),
                        )
                      ],
                    ))));
  }
}

void showBidBottomSheet(BuildContext ctx, Listing listing) {
  showModalBottomSheet(
      context: ctx, builder: (sheetContext) => MakeBidding(listing));
}
