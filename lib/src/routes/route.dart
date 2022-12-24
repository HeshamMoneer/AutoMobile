import 'package:AutoMobile/src/screens/create_listing_screen.dart';
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
      '/createListing': (ctx) => CreateListingScreen()
    };
  }
}
