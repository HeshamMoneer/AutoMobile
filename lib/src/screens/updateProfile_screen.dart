import 'dart:io';

import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:AutoMobile/src/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/user.dart';
import '../provider/provider.dart';
import 'package:provider/provider.dart';

import '../themes/theme.dart';

class UpdateProfileScreen extends StatelessWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

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
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        NetworkImage(curUser!.profilePicPath),
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
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    color: ThemeColor.lightblack),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      final _imagePicker = ImagePicker();
                                      XFile? image;
                                      //Check Permissions
                                      await Permission.photos.request();

                                      var permissionStatus =
                                          await Permission.photos.status;

                                      if (permissionStatus.isGranted) {
                                        //Select Image
                                        image = await _imagePicker.pickImage(
                                            source: ImageSource.gallery);

                                        if (image != null) {
                                          var file = File(image.path);
                                          //Upload to Firebase
                                          var downloadUrl = await AllProvider()
                                              .repository
                                              .fireBaseHandler
                                              .uploadProfilePic(
                                                  AllProvider()
                                                      .repository
                                                      .fireBaseHandler
                                                      .getCurrentUserId(),
                                                  file);
                                          curUser.profilePicPath = downloadUrl;
                                          myProvider.updateCurrentUser(curUser);
                                        } else {
                                          print('No Image Path Received');
                                        }
                                      } else {
                                        print(
                                            'Permission not granted. Try Again with permission access');
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 246, 244, 244),
                                    )),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                      labelText: "First Name",
                      controller: firstNameController,
                      placeHolder: curUser.firstName,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        style: AppTheme.buttonStyleWhite,
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
                        style: AppTheme.buttonStyleBlack,
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
      title: Text("Edit Profile",
          style: AppTheme
              .titleStyle2), //TextStyle(color: ThemeColor.titleTextColor)),
    );
    return Scaffold(appBar: appBar, body: body);
  }
}
