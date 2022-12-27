import 'dart:ui';

import 'package:AutoMobile/src/models/user.dart';
import "package:flutter/material.dart";
import 'package:gender_picker/source/enums.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/provider.dart';
import 'package:provider/provider.dart';

import '../repository/errorhandler.dart';
import 'package:gender_picker/source/gender_picker.dart';

import '../widgets/GenderPicker.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});
  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var userGender = true;
  bool login = true;

  void registerUser() {
    // print("we are not here");

    // problem here that the listen not true and when i make it false it's not inserting user into the db only register it
    var allProvider = Provider.of<AllProvider>(context, listen: true);
    var user = User(
        id: "",
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        joiningDate: DateTime.now(),
        isMale: userGender);
    // print(user.firstName);
    allProvider.addUser(user);
  }

  void toggleMode() {
    setState(() {
      //   print("heeeeeeeeeer${login}");
      login = !login;
    });
  }

  void loginORsignup() async {
    final myprovider = Provider.of<AllProvider>(context, listen: true);
    try {
      if (!login) {
        if (passwordController.text == confirmPasswordController.text) {
          try {
            var result = await myprovider.repository.fireBaseHandler
                .signup(emailController.text, passwordController.text);
            registerUser();
          } catch (e) {
            throw ErrorHandler(e.toString());
          }
        } else {
          throw ErrorHandler("The passwords do not match");
        }
      } else {
        var result = await myprovider.repository.fireBaseHandler
            .login(emailController.text, passwordController.text);
      }
      Navigator.of(context).pushReplacementNamed('/mainscreen');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gender = GenderPicker(
      showOtherGender: false,
      verticalAlignedText: false,
      selectedGender: Gender.Male,
      selectedGenderTextStyle:
          TextStyle(color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
      unSelectedGenderTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      onChanged: (gender) {
        if (gender == Gender.Male) {
          userGender = true;
        } else {
          userGender = false;
        }
      },
      equallyAligned: true,
      animationDuration: Duration(milliseconds: 300),
      isCircular: true,
      // default : true,
      opacityOfGradient: 0.4,
      padding: const EdgeInsets.all(10),
      size: 50, //default : 40
    );

    final loginWidget = SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.car_rental,
                size: 100,
                color: Colors.black,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Hello Again!",
                style: GoogleFonts.bebasNeue(fontSize: 50),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Welcome back, you 've been missed!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Email "),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Password "),
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (() {
                  loginORsignup();
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12)),
                    child: GestureDetector(
                      child: Center(
                          child: Text(
                        "Sign in",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member yet?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: (() => toggleMode()),
                      child: Text(" Register Now",
                          style: TextStyle(color: Colors.blue))),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final signUpWidget = SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.car_rental,
                size: 50,
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Hello There",
                style: GoogleFonts.bebasNeue(fontSize: 45),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Register now with your details!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "First Name "),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Last Name "),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Phone Number "),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Email "),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 10,
              ),
              gender,
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Password "),
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password "),
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (() {
                  loginORsignup();
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12)),
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: (() {
                        toggleMode();
                      }),
                      child: Text(" Login Now",
                          style: TextStyle(color: Colors.blue))),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: login ? loginWidget : signUpWidget);
  }
}
