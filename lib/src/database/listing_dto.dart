import '../models/listing.dart';
import 'dto.dart';

class ListingDTO implements DTO {
  Map<String, dynamic> ModelToJson(Object model) {
    Listing listing = model as Listing;
    List<String> bidIDs = [];
    listing.bids.forEach((bid) => bidIDs.add(bid.id));

    return {
      "user": listing.userId,
      "id": listing.id,
      "title": listing.title,
      "description": listing.description,
      "imageUrls": listing.imageUrls,
      "bids": bidIDs,
      "initialPrice": listing.initialPrice,
      "creationDate": listing.creationDate,
      "endBidDate": listing.endBidDate
    };
  }

  @override
  Listing? JsonToModel(Map<String, dynamic> json) {
    return null;
  }
}
