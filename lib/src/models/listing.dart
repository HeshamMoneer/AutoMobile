import 'Bid.dart';
import 'user.dart';

class Listing {
  User user;
  String id;
  String title;
  String description;
  List<String> imageUrls;
  List<Bid> bids;
  DateTime endBidDate;
  DateTime creationDate;
  double initialPrice;
  Listing({
    required this.user,
    required this.title,
    required this.id,
    required this.description,
    required this.imageUrls,
    required this.bids,
    required this.endBidDate,
    required this.initialPrice,
    required this.creationDate,
  });
}
