class Bid {
  String id;
  double price;
  String listingId;
  String userId;
  DateTime creationDate;
  Bid(
      {required this.id,
      required this.price,
      required this.listingId,
      required this.userId,
      required this.creationDate});
}
