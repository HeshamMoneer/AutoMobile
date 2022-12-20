import '../models/user.dart';
import 'dto.dart';

class UserDTO implements DTO {
  @override
  Map<String, dynamic> ModelToJson(Object model) {
    User user = model as User;
    List<String> bidIDs = [];
    user.bids.forEach((bid) => bidIDs.add(bid.id));
    List<String> listingIDs = [];
    user.listings.forEach((listing) => bidIDs.add(listing.id));
    List<String> chatsIDs = [];
    user.chats.forEach((chat) => bidIDs.add(chat.id));

    return {
      "id": user.id,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "birthDate": user.birthDate,
      "balance": user.balance,
      "phoneNumber": user.phoneNumber,
      "profilePicPath": user.profilePicPath,
      "isMale": user.isMale,
      "joiningDate": user.joiningDate.toString(),
      "bids": bidIDs,
      "listings": listingIDs,
      "chats": chatsIDs
    };
  }
}
