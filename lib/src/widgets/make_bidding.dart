import 'package:AutoMobile/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../models/listing.dart';
import '../themes/theme_color.dart';

class MakeBidding extends StatefulWidget {
  final Listing listing;

  MakeBidding(this.listing);

  @override
  State<MakeBidding> createState() => _MakeBiddingState();
}

class _MakeBiddingState extends State<MakeBidding> {
  int _bidAmount = 0;

  @override
  void initState(){
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

    void onMakeBidding() {
      //TODO: call provider to make a bidding

      Navigator.of(context).pop();
    }

    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: NumberPicker(
                      value: _bidAmount,
                      minValue: minBidAmount,
                      maxValue: maxBidAmount,
                      step: bidAmountStep,
                      itemHeight: 100,
                      haptics: true,                      
                      axis: Axis.horizontal,
                      onChanged: (value) =>
                          setState(() => _bidAmount = value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.blue, width: 2),
                      ),
                    )),
                TextButton(
                    onPressed: onMakeBidding,
                    child: Text(
                      "Bid",
                      style: AppTheme.titleStyle,
                    )),
              ],
            )));
  }
}

void showBidBottomSheet(BuildContext ctx, Listing listing) {
  showModalBottomSheet(
      context: ctx, builder: (sheetContext) => MakeBidding(listing));
}
