import 'bid.dart';
import 'chat.dart';
import 'listing.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String birthDate;
  double balance;
  String phoneNumber;
  String profilePicPath;
  bool isMale;
  String joiningDate;
  List<Bid>? bids;
  List<Listing>? listings;
  List<Chat>? chats;

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
      this.bids,
      this.listings,
      this.chats});
}
