import 'package:AutoMobile/src/screens/create_listing_screen.dart';
<<<<<<< HEAD
=======
import 'package:AutoMobile/src/screens/chat_screen.dart';
import 'package:AutoMobile/src/screens/inbox_screen.dart';
>>>>>>> d9ac9c549e1d2e9b8a1bfa66036de7767215613a
import 'package:AutoMobile/src/screens/listings_screen.dart';
import 'package:flutter/material.dart';

import '../screens/listingDetail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      '/': (ctx) => LoginScreen(),
      '/mainscreen': (ctx) => MainScreen(),
      '/listings': (ctx) => ListingsScreen(),
      '/listingDetail': (ctx) => ListingDetailScreen(),
<<<<<<< HEAD
      '/createListing': (ctx) => CreateListingScreen()
=======
      '/createListing': (ctx) => CreateListingScreen(),
      '/inbox': (ctx) => InboxScreen(),
      '/inbox/chat': (ctx) => ChatScreen()
>>>>>>> d9ac9c549e1d2e9b8a1bfa66036de7767215613a
    };
  }
}
