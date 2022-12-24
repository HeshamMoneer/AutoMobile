import 'package:AutoMobile/src/screens/listings_screen.dart';
import 'package:AutoMobile/src/screens/userProfile_screen.dart';
import 'package:flutter/material.dart';

import '../screens/listingDetail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/updateProfile_screen.dart';
import '../screens/userProfile_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      '/': (ctx) => LoginScreen(),
      '/profilescreen': (ctx) => UserProfileScreen(),
      '/editprofilescreen': (ctx) => UpdateProfileScreen(),
      '/mainscreen': (ctx) => MainScreen(),
      '/listings': (ctx) => ListingsScreen(),
      '/listingDetail': (ctx) => ListingDetailScreen()
    };
  }
}
