import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';

import 'package:AutoMobile/src/models/user.dart';
import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen();
  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<AllProvider>(context);
    String? anotherUserId =
        ModalRoute.of(context)!.settings.arguments as String?;
    bool isMe = anotherUserId == null;
    Future<User> user = isMe
        ? myProvider.getCurrentUser()
        : myProvider.getUserById(anotherUserId);

    final appBar = AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.arrow_back),
      ),
      actions: [
        !isMe
            ? IconButton(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble_outline_outlined))
            : Container()
      ],
      title: Text("Profile",
          style: AppTheme
              .titleStyle2), //TextStyle(color: ThemeColor.titleTextColor)),
    );

    final editProfile = SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          //TODO: go to the edit profile route
        },
        child: Text(
          "Edit profile",
          style: AppTheme.subTitleStyle,
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColor.lightblack,
            side: BorderSide.none,
            shape: StadiumBorder()),
      ),
    );

    final settings = ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.settings, color: ThemeColor.lightblack),
        ),
        title: Text("Settings", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.16)),
            child: GestureDetector(
              onTap: () {
                // print("here");
              },
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18, color: Color.fromARGB(255, 58, 57, 57)),
            )));
    // container

    final privacy = ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.privacy_tip, color: ThemeColor.lightblack),
        ),
        title: Text("Privacy", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.16)),
            child: GestureDetector(
              onTap: () {
                // print("here");
              },
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18, color: Color.fromARGB(255, 58, 57, 57)),
            )));

    final mybids = ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.post_add, color: ThemeColor.lightblack),
        ),
        title: Text("My Bids", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.16)),
            child: GestureDetector(
              onTap: () {
                // print("here");
              },
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18, color: Color.fromARGB(255, 58, 57, 57)),
            )));

    final logout = ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.logout, color: ThemeColor.lightblack),
        ),
        title: Text("Log out", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.16)),
            child: GestureDetector(
              onTap: () {
                // print("here");
              },
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18, color: Color.fromARGB(255, 58, 57, 57)),
            )));

    final profileImage = FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? curUser = snapshot.data;
          return Container(
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
                            curUser!.profilePicPath,
                            fit: BoxFit.cover,
                          )),
                    ),
                    if (isMe)
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ThemeColor.lightblack),
                            child: IconButton(
                              icon: Icon(LineAwesomeIcons.alternate_pencil,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                //TODO: upload new profile picture
                              },
                            ),
                          ))
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${curUser.firstName} ${curUser.lastName}",
                    style: AppTheme.titleStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${curUser.email}',
                    style: AppTheme.titleStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (isMe) editProfile,
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Birth Date: ${curUser.birthDate}',
                        style: AppTheme.h6Style,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Gender: ${curUser.isMale ? "Male" : "Female"}',
                        style: AppTheme.h6Style,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Phone Number: ${curUser.phoneNumber}',
                        style: AppTheme.h6Style,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Joining Date: ${curUser.joiningDate}',
                        style: AppTheme.h6Style,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      settings,
                      privacy,
                      mybids,
                      logout
                    ],
                  )
                ],
              ));
        } else if (snapshot.hasError) {
          return ErrorWidget(
              "The user data could not be found!! + ${snapshot.error}");
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    return Scaffold(
      appBar: appBar,
      body: Center(child: profileImage),
    );
  }
}
