import 'bid.dart';
import 'chat.dart';
import 'listing.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  DateTime? birthDate;
  double balance;
  String phoneNumber;
  String profilePicPath;
  bool isMale;
  DateTime joiningDate;
  List<Bid>? bids;
  List<Listing>? listings;
  List<Chat>? chats;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.birthDate,
      this.balance = 0.0,
      required this.phoneNumber,
      required this.joiningDate,
      this.profilePicPath =
          "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png",
      required this.isMale,
      this.bids,
      this.listings,
      this.chats});
}
