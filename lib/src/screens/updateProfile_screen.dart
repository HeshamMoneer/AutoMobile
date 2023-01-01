import 'dart:ffi';

import 'package:AutoMobile/src/widgets/textField.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final body = Container(
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
                            image: NetworkImage(
                              "https://img.freepik.com/premium-vector/young-man-avatar-cartoon-character-profile-picture_18591-55055.jpg?w=740",
                            ),
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
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.blue),
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextField(
                labelText: "Mohamed", placeHolder: "Eshiba", isPassword: false),
            CustomTextField(
                labelText: "Mohamed", placeHolder: "Eshiba", isPassword: false),
            CustomTextField(
                labelText: "Mohamed", placeHolder: "Eshiba", isPassword: false),
            CustomTextField(
                labelText: "Mohamed", placeHolder: "Eshiba", isPassword: false),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 15, letterSpacing: 2, color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 15, letterSpacing: 2, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    return Scaffold(body: body);
  }
}
