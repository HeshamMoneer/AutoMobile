import 'bid.dart';
import 'user.dart';
import 'package:timeago/timeago.dart' as timeago;

class Listing {
  String userId;
  String id;
  String title;
  String description;
  List<String> imageUrls;
  List<Bid> bids;
  DateTime endBidDate;
  DateTime creationDate;
  double initialPrice;
  Listing({
    required this.userId,
    required this.title,
    required this.id,
    required this.description,
    required this.imageUrls,
    required this.bids,
    required this.endBidDate,
    required this.initialPrice,
    required this.creationDate,
  });

  List<String> get imagesOrDefault {
    return imageUrls.length > 0
        ? imageUrls
        : [
            "https://img.freepik.com/premium-vector/super-car-line-art-vector-design_500890-331.jpg"
          ];
  }

  bool get biddingEnded {
    return endBidDate.isBefore(DateTime.now());
  }

  String get biddingDurationInWords {
    String duration = timeago.format(endBidDate, allowFromNow: true, locale: "en_short");
    return biddingEnded? '$duration ago':'in $duration';
  }

  double get finalPrice {
    return bids.length > 0 ? bids[bids.length - 1].price : initialPrice;
  }

  int get newBidPrice{
    int lastPrice = finalPrice.floor() + 1;
    int diffToHundredMultiple =  100 - (lastPrice % 100);
    return lastPrice + diffToHundredMultiple;
  }
}

var dummyListings = [
  Listing(
      userId: "1",
      title: "Chevrolet Lanos 2015 silver very good wowwwwhwhhwfdsljn dsjl",
      id: "1",
      description:
          "Chevrolet car in very good condition located in alexandria 1500km",
      imageUrls: [],
      bids: [],
      endBidDate: DateTime.now().add(Duration(days: 3)),
      initialPrice: 120000,
      creationDate: DateTime.now()),
  Listing(
      userId: "1",
      title: "Toyota corolla 2020",
      id: "2",
      description: "toyota for sale in a short period need money to travel",
      imageUrls: [
        "https://media.hatla2eestatic.com/uploads/car/2022/11/29/5289779/full_up_aec9692a7bf752d2c33c16f63351bb60.jpg"
      ],
      bids: [
        Bid(
            id: "2",
            price: 101000,
            listingId: "2",
            userId: "1",
            creationDate: DateTime.now().subtract(Duration(days: 10)))
      ],
      endBidDate: DateTime.now().subtract(Duration(days: 8)),
      initialPrice: 99000,
      creationDate: DateTime.now().subtract(Duration(days: 20))),
];
