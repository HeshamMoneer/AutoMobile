import 'dart:core';
import 'package:AutoMobile/src/database/dto.dart';
import 'package:AutoMobile/src/database/firebasehandler.dart';
import 'package:AutoMobile/src/database/user_dto.dart';
import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/repository/repository.dart';
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

class userprovider {
  Repository repository;
  userprovider({required this.repository});
}
