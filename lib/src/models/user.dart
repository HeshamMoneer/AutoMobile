import 'Bid.dart';
import 'inbox/inbox.dart';
import 'listing.dart';
import 'user_info.dart';

class User {
  String id;
  UserInfo userInfo;
  DateTime joiningDate;
  List<Bid> bids;
  List<Listing> listings;
  Inbox inbox;

  User(
      {required this.id,
      required this.userInfo,
      required this.joiningDate,
      required this.bids,
      required this.listings,
      required this.inbox});
}
