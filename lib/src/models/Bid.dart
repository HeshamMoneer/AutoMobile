import 'package:AutoMobile/src/models/listing.dart';

import 'User.dart';

class Bid {
  String id;
  double price;
  Listing listing;
  User user;
  DateTime creationDate;
  Bid(
      {required this.id,
      required this.price,
      required this.listing,
      required this.user,
      required this.creationDate});
}
