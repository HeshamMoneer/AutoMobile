import 'dart:core';
import 'package:AutoMobile/src/database/dto.dart';
import 'package:AutoMobile/src/database/user_dto.dart';
import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../database/bid_dto.dart';
import '../database/listing_dto.dart';
import '../models/bid.dart';
import '../models/user.dart';

class AllProvider with ChangeNotifier {
  // ============================================ instance variables

  Repository repository = Repository();
  Map<String, Listing> listings = Map();
  DTO listing_dto = ListingDTO();
  Map<String, User> users = Map();
  DTO user_dto = UserDTO();
  Map<String, Bid> bids = Map();
  DTO bid_dto = BidDTO();

  //================================================== current user getter

  Future<User> getCurrentUser() async {
    return getUserById(repository.fireBaseHandler.getCurrentUserId());
  }

  String getCurrentUserId() {
    return repository.fireBaseHandler.getCurrentUserId();
  }

  //=================================================== adding new model

  Future<String> addUser(User user) async {
    String userId = await repository.post("user", user, user_dto);
    user.id = userId;
    users[userId] = user;
    notifyListeners();
    return userId;
  }

  Future<String> addListing(Listing listing) async {
    String listingId = await repository.post("listing", listing, listing_dto);
    listing.id = listingId;
    listings[listingId] = listing;
    User user = await getUserById(listing.userId);
    user.listings.add(listing);
    await Future.wait([
      repository.patch("listing", listing.id, listing, listing_dto),
      repository.patch("user", user.id, user, user_dto)
    ]);
    notifyListeners();
    return listingId;
  }

  Future<String> addBid(Bid bid) async {
    String bidId = await repository.post("bid", bid, bid_dto);
    bid.id = bidId;
    bids[bidId] = bid;
    Listing listing = await getListingById(bid.listingId);
    listing.bids.add(bid);
    User user = await getCurrentUser();
    user.bids.add(bid);
    await Future.wait([
      repository.patch("bid", bid.id, bid, bid_dto),
      repository.patch("listing", listing.id, listing, listing_dto),
      repository.patch("user", user.id, user, user_dto)
    ]);
    notifyListeners();
    return bidId;
  }

  Future<void> sendMessage(String messageContent, String to_userId) async {
    await repository.fireBaseHandler.post("message", {
      "content": messageContent,
      "seen": false,
      "sentDate": DateTime.now(),
      "users": [getCurrentUserId(), to_userId]
    });
  }

  Future<void> markAsSeen(String messageId) async {
    await repository.fireBaseHandler
        .patch("message", messageId, {"seen": true});
  }

  //========================================================= converting json to model

  User JsonToUser(Map<String, dynamic> user) {
    List<Listing> listings = [];
    List<Bid> bids = [];
    user["listings"].forEach((Element) async {
      Listing listing = await getListingById(Element);
      listings.add(listing);
    });
    user["bids"].forEach((Element) async {
      Bid bid = await getBidById(Element);
      bids.add(bid);
    });
    var userModel = User(
        id: user["id"],
        firstName: user["firstName"],
        lastName: user["lastName"],
        email: user["email"],
        birthDate: user["birthDate"],
        balance: user["balance"],
        phoneNumber: user["phoneNumber"],
        profilePicPath: user["profilePicPath"],
        isMale: user["isMale"],
        joiningDate: user["joiningDate"],
        bids: bids,
        listings: listings);
    return userModel;
  }

  Bid JsonToBid(Map<String, dynamic> bid) {
    var bidModel = Bid(
        id: bid["id"],
        price: bid["price"],
        listingId: bid["listing"],
        userId: bid["user"],
        creationDate: bid["creationDate"].toDate());
    return bidModel;
  }

  Listing JsonToListing(Map<String, dynamic> listing) {
    List<Bid> bids = [];
    listing["bids"].forEach((Element) async {
      Bid bid = await getBidById(Element);
      bids.add(bid);
    });
    List<String> imageUrls = [];
    listing["imageUrls"].forEach((Element) async {
      imageUrls.add(Element);
    });
    var listingModel = Listing(
        userId: listing["user"],
        title: listing["title"],
        id: listing["id"],
        description: listing["description"],
        imageUrls: imageUrls,
        bids: bids,
        endBidDate: listing["endBidDate"].toDate(),
        initialPrice: listing["initialPrice"],
        creationDate: listing["creationDate"].toDate());
    return listingModel;
  }

  //================================================= get by id

  Future<Bid> getBidById(String id) async {
    if (bids.containsKey(id)) {
      return bids[id]!;
    }
    var jsonData = await repository.get("bid", id);
    Bid bid = JsonToBid(jsonData);
    bids[bid.id] = bid;
    notifyListeners();
    return bid;
  }

  Future<Listing> getListingById(String id) async {
    if (listings.containsKey(id)) {
      return listings[id]!;
    }
    var jsonData = await repository.get("listing", id);
    Listing list = JsonToListing(jsonData);
    listings[list.id] = list;
    notifyListeners();
    return list;
  }

  Future<User> getUserById(String id) async {
    if (users.containsKey(id)) {
      return users[id]!;
    }
    var jsonData = await repository.get("user", id);
    User user = JsonToUser(jsonData);
    users[user.id] = user;
    notifyListeners();
    return user;
  }

  //================================================= Fetch data
  Future<void> fetchUsers() async {
    var data = await repository.getAll("user");
    users.clear();
    data.forEach((element) {
      users[element["id"]] = JsonToUser(element);
    });
    notifyListeners();
  }

  Future<void> fetchListings() async {
    var data = await repository.getAll("listing");
    listings.clear();
    data.forEach((element) {
      listings[element["id"]] = JsonToListing(element);
    });
    notifyListeners();
  }

  Future<void> fetchBids() async {
    var data = await repository.getAll("bid");
    bids.clear();
    data.forEach((element) {
      bids[element["id"]] = JsonToBid(element);
    });
    notifyListeners();
  }

  //========================== update

  Future<void> updateCurrentUser(User user) async {
    await this
        .repository
        .patch("user", this.getCurrentUserId(), user, user_dto);
  }

  //================================================= getters

  Map<String, User> get getAllUsers {
    return this.users;
  }

  Map<String, Listing> get getAllListings {
    return this.listings;
  }

  Map<String, Bid> get getAllBids {
    return this.bids;
  }

  //================================================= getters with fetch
  List<Listing> getAllListingsAsList({bool fetch = false}) {
    if (fetch) fetchListings();
    return getAllListings.values.toList();
  }

  Future<List<User>> getAllUsersAsList() async {
    await fetchUsers();
    return getAllUsers.values.toList();
  }

  //================================================= deletions
  Future<void> deleteListing(Listing listing) async {
    List<Future> futures = [];
    listing.bids.forEach((bid) =>
        futures.add(deleteBid(bid, notify: false, deleteFromListing: false)));
    futures.add(repository.delete("listing", listing.id, listing_dto));
    listings.remove(listing.id);
    User user = await getUserById(listing.userId);
    user.listings.removeWhere((element) => element.id == listing.id);
    futures.add(repository.patch("user", user.id, user, user_dto));
    await Future.wait(futures);
    notifyListeners();
  }

  Future<void> deleteBid(Bid bid,
      {bool notify = true, bool deleteFromListing = true}) async {
    List<Future> futures = [];
    futures.add(repository.delete("bid", bid.id, bid_dto));
    bids.remove(bid.id);
    if (deleteFromListing) {
      Listing listing = await getListingById(bid.listingId);
      listing.bids.removeWhere((element) => element.id == bid.id);
      futures
          .add(repository.patch("listing", listing.id, listing, listing_dto));
    }
    User user = await getUserById(bid.userId);
    user.bids.removeWhere((element) => element.id == bid.id);
    futures.add(repository.patch("user", user.id, user, user_dto));
    await Future.wait(futures);
    if (notify) notifyListeners();
  }
}
