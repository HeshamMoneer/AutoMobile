import 'dart:ffi';

import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:AutoMobile/src/widgets/textField.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../provider/provider.dart';
import 'package:provider/provider.dart';

import '../themes/theme.dart';

class UpdateProfileScreen extends StatelessWidget {
  //const UpdateProfileScreen({super.key});
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<AllProvider>(context);
    Future<User> user = myProvider.getCurrentUser();
    final body = FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? curUser = snapshot.data;
          return Container(
            padding: EdgeInsets.only(left: 15, top: 20, right: 15),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(curUser!.profilePicPath),
                                  fit: BoxFit.cover)),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  color: ThemeColor.lightblack),
                              child: Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 246, 244, 244),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                      labelText: "First Name",
                      controller: firstNameController,
                      placeHolder: curUser!.firstName,
                      isPassword: false),
                  CustomTextField(
                      controller: lastNameController,
                      labelText: "Last Name",
                      placeHolder: curUser.lastName,
                      isPassword: false),
                  CustomTextField(
                      labelText: "Phone Number",
                      controller: phoneNumberController,
                      placeHolder: curUser.phoneNumber,
                      isPassword: false),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.black),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          curUser.firstName = firstNameController.text == ""
                              ? curUser.firstName
                              : firstNameController.text;
                          curUser.lastName = lastNameController.text == ""
                              ? curUser.lastName
                              : lastNameController.text;
                          curUser.phoneNumber = phoneNumberController.text == ""
                              ? curUser.phoneNumber
                              : phoneNumberController.text;
                          myProvider
                              .updateCurrentUser(curUser)
                              .then((value) => Navigator.of(context).pop());
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: ThemeColor.lightblack,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
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
    final appBar = AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.arrow_back),
      ),

      title: Text("Edit Profile",
          style: AppTheme
              .titleStyle2), //TextStyle(color: ThemeColor.titleTextColor)),
    );
    return Scaffold(appBar: appBar, body: body);
  }
}
