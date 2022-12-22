import 'dart:core';
import 'package:AutoMobile/src/database/dto.dart';
import 'package:AutoMobile/src/database/firebasehandler.dart';
import 'package:AutoMobile/src/database/user_dto.dart';
import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/models/message.dart';
import 'package:AutoMobile/src/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../database/bid_dto.dart';
import '../database/chat_dto.dart';
import '../database/listing_dto.dart';
import '../models/bid.dart';
import '../models/chat.dart';
import '../models/user.dart';

class AllProvider with ChangeNotifier {
  Repository repository = Repository();

  Map<String, Listing> listings = Map();
  DTO listing_dto = ListingDTO();
  Map<String, User> users = Map();
  DTO user_dto = UserDTO();
  Map<String, Chat> chats = Map();
  DTO chat_dto = ChatDTO();
  Map<String, Bid> bids = Map();
  DTO bid_dto = BidDTO();

  //===================================================

  Future<String> addUser(User user) async {
    users[user.id] = user;
    notifyListeners();
    return repository.post("user", user, user_dto);
  }

  Future<String> addListing(Listing listing) async {
    listings[listing.id] = listing;
    notifyListeners();
    return repository.post("listing", listing, listing_dto);
  }

  Future<String> addChat(Chat chat) async {
    chats[chat.id] = chat;
    notifyListeners();
    return repository.post("chat", chat, chat_dto);
  }

  Future<String> addBid(Bid bid) async {
    return repository.post("bid", bid, bid_dto);
  }
  //=========================================================

  User JsonToUser(Map<String, dynamic> user) {
    List<Listing> listings = [];
    List<Chat> chats = [];
    List<Bid> bids = [];
    user["listings"].forEach((Element) async {
      Listing listing = await getListingById(Element);
      listings.add(listing);
    });
    user["bids"].forEach((Element) async {
      Bid bid = await getBidById(Element);
      bids.add(bid);
    });
    user["chats"].forEach((Element) async {
      Chat chat = await getChatById(Element);
      chats.add(chat);
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
        listings: listings,
        chats: chats);
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

  Chat JsonToChat(Map<String, dynamic> chat) {
    List<Message> messages = [];

    chat["messages"].forEach((Element) {
      Message message = Message(
          content: Element["content"],
          sentDate: Element["sentDate"],
          seen: Element["seen"],
          senderId: Element["senderId"]);
      messages.add(message);
    });
    var chatModel = Chat(
        user1Id: chat["user1_id"],
        user2Id: chat["user2_id"],
        id: chat["id"],
        lastUpdated: chat["lastUpdated"],
        messages: messages);

    return chatModel;
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

  Future<Chat> getChatById(String id) async {
    if (chats.containsKey(id)) {
      return chats[id]!;
    }
    var jsonData = await repository.get("chat", id);
    Chat chat = JsonToChat(jsonData);
    chats[chat.id] = chat;
    notifyListeners();
    return chat;
  }

  //================================================= Fetch data
  Future<void> fetchUsers() async {
    var data = await repository.getAll("user");
    data.forEach((element) {
      users[element["id"]] = JsonToUser(element);
    });
    notifyListeners();
  }

  Future<void> fetchChats() async {
    var data = await repository.getAll("chat");
    data.forEach((element) {
      chats[element["id"]] = JsonToChat(element);
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

  //=================================================

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

  Map<String, Chat> get getAllChats {
    return this.chats;
  }

  // TODO:Define here whatever methods you need to implement for any model
}
