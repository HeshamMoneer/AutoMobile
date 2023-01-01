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
      title: Text("Profile",
          style: AppTheme
              .titleStyle), //TextStyle(color: ThemeColor.titleTextColor)),
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
            backgroundColor: ThemeColor.yellowColor,
            side: BorderSide.none,
            shape: StadiumBorder()),
      ),
    ); // container

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
                                color: Colors.yellow),
                            child: IconButton(
                              icon: Icon(LineAwesomeIcons.alternate_pencil,
                                  color: Colors.black, size: 20),
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
