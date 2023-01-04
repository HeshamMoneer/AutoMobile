import 'package:flutter/material.dart';

Widget inputField(placeholder, controller,
    {obscureText = false, isEmail = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: TextField(
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          controller: controller,
          obscureText: obscureText,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: placeholder),
        ),
      ),
    ),
  );
}
