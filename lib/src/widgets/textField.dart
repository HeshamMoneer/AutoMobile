import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String labelText;
  String placeHolder;
  bool isPassword;
  TextEditingController controller;
  CustomTextField(
      {required this.labelText,
      required this.placeHolder,
      required this.isPassword,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPassword ? true : false,
        controller: this.controller,
        decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: this.labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: this.placeHolder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
