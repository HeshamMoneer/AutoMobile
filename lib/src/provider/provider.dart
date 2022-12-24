import 'dart:core';
import 'package:AutoMobile/src/database/dto.dart';
import 'package:AutoMobile/src/database/user_dto.dart';
import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/models/message.dart';
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
    notifyListeners();
    return listingId;
  }

  Future<String> addBid(Bid bid) async {
    String bidId = await repository.post("bid", bid, bid_dto);
    bid.id = bidId;
    bids[bidId] = bid;
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
        creationDate: bid["creationDate"]);
    return bidModel;
  }

  Listing JsonToListing(Map<String, dynamic> listing) {
    List<Bid> bids = [];
    listing["bids"].forEach((Element) async {
      Bid bid = await getBidById(Element);
      bids.add(bid);
    });
    var listingModel = Listing(
        userId: listing["user"],
        title: listing["title"],
        id: listing["id"],
        description: listing["description"],
        imageUrls: listing["imageUrls"],
        bids: bids,
        endBidDate: listing["endBidDate"],
        initialPrice: listing["initialPrice"],
        creationDate: listing["creationDate"]);
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
    data.forEach((element) {
      users[element["id"]] = JsonToUser(element);
    });
    notifyListeners();
  }

  Future<void> fetchListing() async {
    var data = await repository.getAll("listing");
    data.forEach((element) {
      listings[element["id"]] = JsonToListing(element);
    });
    notifyListeners();
  }

  Future<void> fetchBids() async {
    var data = await repository.getAll("bid");
    data.forEach((element) {
      bids[element["id"]] = JsonToBid(element);
    });
    notifyListeners();
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

  // TODO: Deletions and updates are still missing

  // TODO:Define here whatever methods you need to implement for any model

  // try to separate methods related to all models in one section as above
}
