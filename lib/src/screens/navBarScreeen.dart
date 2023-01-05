import 'package:AutoMobile/src/screens/userProfile_screen.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:flutter/material.dart';

import 'inbox_screen.dart';

import 'main_screen.dart';
import 'my_listings_screen.dart';

class NavBarScreen extends StatefulWidget {
  @override
  State<NavBarScreen> createState() => NavBarScreenState();
}

class NavBarScreenState extends State<NavBarScreen> {
  static var selectedTabIndex = 0;
  final List<Widget> myPages = [
    MainScreen(),
    InboxScreen(),
    UserProfileScreen(),
    MyListingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPages[selectedTabIndex],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/createListing');
        },
        backgroundColor: ThemeColor.lightblack,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          color: ThemeColor.lightblack,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        selectedTabIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: selectedTabIndex == 0
                              ? ThemeColor.white
                              : Color.fromARGB(255, 117, 116, 116),
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: selectedTabIndex == 0
                                  ? ThemeColor.white
                                  : Colors.grey),
                        )
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        selectedTabIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          color: selectedTabIndex == 1
                              ? ThemeColor.white
                              : Colors.grey,
                        ),
                        Text(
                          "Inbox",
                          style: TextStyle(
                              color: selectedTabIndex == 1
                                  ? ThemeColor.white
                                  : Colors.grey),
                        )
                      ],
                    ),
                    minWidth: 40,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        selectedTabIndex = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: selectedTabIndex == 2
                              ? ThemeColor.white
                              : Colors.grey,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              color: selectedTabIndex == 2
                                  ? ThemeColor.white
                                  : Colors.grey),
                        )
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        selectedTabIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_rounded,
                          color: selectedTabIndex == 3
                              ? ThemeColor.white
                              : Colors.grey,
                        ),
                        Text(
                          "My listings",
                          style: TextStyle(
                              color: selectedTabIndex == 3
                                  ? ThemeColor.white
                                  : Colors.grey),
                        )
                      ],
                    ),
                    minWidth: 40,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
