import 'package:AutoMobile/src/screens/userProfile_screen.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'create_listing_screen.dart';
import 'inbox_screen.dart';

import 'main_screen.dart';

class NavBarScreen extends StatefulWidget {
  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  var selectedTabIndex = 0;
  final List<Widget> myPages = [
    MainScreen(),
    InboxScreen(),
    UserProfileScreen(),
    CreateListingScreen()
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
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
                          color:
                              selectedTabIndex == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: selectedTabIndex == 0
                                  ? Colors.blue
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
                          color:
                              selectedTabIndex == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Inbox",
                          style: TextStyle(
                              color: selectedTabIndex == 1
                                  ? Colors.blue
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
                          color:
                              selectedTabIndex == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              color: selectedTabIndex == 2
                                  ? Colors.blue
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
                          Icons.home,
                          color:
                              selectedTabIndex == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Addd",
                          style: TextStyle(
                              color: selectedTabIndex == 3
                                  ? Colors.blue
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
