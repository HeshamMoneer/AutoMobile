import 'Bid.dart';
import 'inbox/inbox.dart';
import 'listing.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  DateTime birthDate;
  double balance;
  String phoneNumber;
  String profilePicPath;
  bool isMale;
  DateTime joiningDate;
  List<Bid> bids;
  List<Listing> listings;
  Inbox inbox;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.birthDate,
      required this.balance,
      required this.phoneNumber,
      required this.profilePicPath,
      required this.isMale,
      required this.joiningDate,
      required this.bids,
      required this.listings,
      required this.inbox});
}
