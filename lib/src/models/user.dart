import 'package:AutoMobile/src/models/Bid.dart';
import 'package:AutoMobile/src/models/inbox/inbox.dart';
import 'package:AutoMobile/src/models/post.dart';
import 'package:AutoMobile/src/models/user_info.dart';

class User {
  String id;
  UserInfo userInfo;
  double totalRatings;
  bool isVerified;
  int noCurrentBids;
  int noCurrentListings;
  int noReviews;
  DateTime joiningDate;
  List<Bid> bids;
  List<Post> posts;
  Inbox inbox;

  User(
      {required this.id,
      required this.userInfo,
      required this.totalRatings,
      required this.isVerified,
      required this.noCurrentBids,
      required this.noCurrentListings,
      required this.noReviews,
      required this.joiningDate,
      required this.bids,
      required this.posts,
      required this.inbox});
}
