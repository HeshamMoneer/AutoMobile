import 'dart:ffi';
import 'dart:ui';

import 'package:AutoMobile/src/models/user.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen();
  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User user = User(
      id: "1",
      firstName: "Mohamed",
      lastName: "Eshiba",
      email: "Mohamedeshiba08@gmail.com",
      birthDate: "30/06/2000",
      balance: 30.5,
      phoneNumber: "01200291121",
      profilePicPath: "profilePicPath",
      isMale: true,
      joiningDate: "30/06/2022",
    );

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final appBar = AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(LineAwesomeIcons.angle_left),
      ),
      title: Text("Profile",
          style: AppTheme
              .titleStyle), //TextStyle(color: ThemeColor.titleTextColor)),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
      ],
    );
    final editProfile = SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          "Edit profile",
          style: AppTheme.subTitleStyle,
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColor.yellowColor,
            side: BorderSide.none,
            shape: StadiumBorder()),
      ),
    );

    final menu = ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(LineAwesomeIcons.cog, color: Colors.red),
        ),
        title: Text("Settings", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1)),
            child: const Icon(LineAwesomeIcons.angle_right,
                size: 18, color: Colors.grey))); // container

    final profileImage = Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "https://img.freepik.com/premium-vector/young-man-avatar-cartoon-character-profile-picture_18591-55055.jpg?w=740",
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.yellow),
                    child: Icon(LineAwesomeIcons.alternate_pencil,
                        color: Colors.black, size: 20),
                  ))
            ]),
            SizedBox(
              height: 10,
            ),
            Text(
              "${user.firstName} ${user.lastName}",
              style: AppTheme.subTitleStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${user.email}',
              style: AppTheme.subTitleStyle,
            ),
            SizedBox(
              height: 10,
            ),
            editProfile,
            SizedBox(
              height: 20,
            ),
            menu,
            menu,
            menu,
            menu,
            Divider(),
            menu
          ],
        ));

    return Scaffold(
      appBar: appBar,
      body: Center(child: profileImage),
    );
  }
}
