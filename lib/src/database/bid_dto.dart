import '../models/bid.dart';
import 'dto.dart';

class BidDTO implements DTO {
  @override
  Map<String, dynamic> ModelToJson(Object model) {
    Bid bid = model as Bid;

    return {
      "id": bid.id,
      "price": bid.price,
      "listing": bid.listingId,
      "user": bid.userId,
      "creationDate": bid.creationDate
    };
  }

  @override
  Bid? JsonToModel(Map<String, dynamic> json) {
    return null;
  }
}
