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
    String duration =
        timeago.format(endBidDate, allowFromNow: true, locale: "en_short");
    return biddingEnded ? '$duration ago' : 'in $duration';
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
      title: "Chevrolet Lanos 2015 silver",
      id: "1",
      description:
          "Chevrolet car in very good condition located in alexandria 1500km",
      imageUrls: [
        "https://th.bing.com/th/id/R.31e9c5ce50745dd1080d10d18bd0514d?rik=BYwlG6Wv2zipGg&riu=http%3a%2f%2fdossier.kiev.ua%2fwp-content%2fuploads%2fchevrolet%2fChevrolet-Lanos-2015-1.jpg&ehk=kvCvdrnmzLN5I7jMxyhUf91pPYMiixmZik%2b30deh%2bno%3d&risl=&pid=ImgRaw&r=0",
        "https://media.hatla2eestatic.com/uploads/car/2022/11/29/5289779/full_up_aec9692a7bf752d2c33c16f63351bb60.jpg",
        "https://media.hatla2eestatic.com/uploads/car/2022/07/15/4901228/full_up_eaaea38d9420c9598e1301e55d40a2cc.jpg"
      ],
      bids: [
        Bid(
            id: '123',
            price: 200000,
            listingId: "1",
            userId: "145",
            creationDate: DateTime.now().add(Duration(days: 1))),
        Bid(
            id: '124',
            price: 200600,
            listingId: "1",
            userId: "144",
            creationDate: DateTime.now().add(Duration(days: 2)))
      ],
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
