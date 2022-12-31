import 'package:AutoMobile/src/screens/create_listing_screen.dart';
import 'package:AutoMobile/src/screens/chat_screen.dart';
import 'package:AutoMobile/src/screens/inbox_screen.dart';
import 'package:AutoMobile/src/screens/listings_screen.dart';
import 'package:flutter/material.dart';

import '../screens/listingDetail_screen.dart';
import '../screens/login_signup_screen.dart';
import '../screens/main_screen.dart';
import '../screens/navBarScreeen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      //'/': (ctx) => NavBarScreen(),
      '/': (ctx) => LoginSignUp(),
      '/mainscreen': (ctx) => NavBarScreen(),
      '/listings': (ctx) => ListingsScreen(),
      '/listingDetail': (ctx) => ListingDetailScreen(),
      '/createListing': (ctx) => CreateListingScreen(),
      '/inbox': (ctx) => InboxScreen(),
      '/inbox/chat': (ctx) => ChatScreen()
    };
  }
}
