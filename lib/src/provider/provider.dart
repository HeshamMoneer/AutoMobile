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

  List<Listing> listings = [];
  DTO listing_dto = ListingDTO();
  List<User> users = [];
  DTO user_dto = UserDTO();
  List<Chat> chats = [];
  DTO chat_dto = ChatDTO();
  List<Bid> bids = [];
  DTO bid_dto = BidDTO();

  Future<String> addUser(User user) async {
    users.add(user);
    notifyListeners();
    return repository.post("user", user, user_dto);
  }

  Future<String> addListing(Listing listing) async {
    listings.add(listing);
    notifyListeners();
    return repository.post("listing", listing, listing_dto);
  }

  Future<String> addChat(Chat chat) async {
    chats.add(chat);
    notifyListeners();
    return repository.post("chat", chat, chat_dto);
  }

  Future<String> addBid(Bid bid) async {
    return repository.post("bid", bid, bid_dto);
  }

  List<User> get getAllUsers {
    return this.users;
  }

  List<Listing> get getAllListings {
    return this.listings;
  }

  List<Bid> get getAllBids {
    return this.bids;
  }

  List<Chat> get getAllChats {
    return this.chats;
  }
  // TODO:Define here whatever methods you need to implement for any model
}
