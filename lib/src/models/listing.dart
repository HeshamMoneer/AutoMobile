import 'Bid.dart';

class Listing {
  String id;
  String title;
  String description;
  List<String> imageUrls;
  List<Bid> bids;
  DateTime endBidTime;
  DateTime creationTime;
  double initialPrice;
  Listing({
    required this.title,
    required this.id,
    required this.description,
    required this.imageUrls,
    required this.bids,
    required this.endBidTime,
    required this.initialPrice,
    required this.creationTime,
  });
}
