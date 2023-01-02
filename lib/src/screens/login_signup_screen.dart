import 'package:AutoMobile/src/models/user.dart';
import 'package:AutoMobile/src/widgets/input_field.dart';
import 'package:AutoMobile/src/widgets/logo.dart';
import 'package:date_field/date_field.dart';
import "package:flutter/material.dart";
import 'package:gender_picker/source/enums.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/provider.dart';
import 'package:provider/provider.dart';

import '../repository/errorhandler.dart';
import 'package:intl/intl.dart';
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
  var birthdateController = DateTime.parse("2005-01-01");
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var userGender = true;
  bool login = true;

  Future<void> registerUser() async {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    var user = User(
        id: "",
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        joiningDate: dateFormat.format(DateTime.now()),
        birthDate: dateFormat.format(birthdateController),
        isMale: userGender);
    await allProvider.addUser(user);
  }

  void toggleMode() {
    setState(() {
      login = !login;
    });
  }

  Future<void> loginORsignup() async {
    final myprovider = Provider.of<AllProvider>(context, listen: false);
    try {
      if (!login) {
        if (passwordController.text == confirmPasswordController.text) {
          try {
            await myprovider.repository.fireBaseHandler
                .signup(emailController.text, passwordController.text);
            await registerUser();
          } catch (e) {
            throw ErrorHandler(e.toString());
          }
        } else {
          throw ErrorHandler("The passwords do not match");
        }
      } else {
        await myprovider.repository.fireBaseHandler
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
              SizedBox(
                height: 20,
              ),
              addLogo(100, true),
              Text(
                "Since 2022",
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
              inputField('Email', emailController),
              SizedBox(
                height: 15,
              ),
              inputField('Password', passwordController, obscureText: true),
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
              SizedBox(
                height: 10,
              ),
              addLogo(50, true),
              Text(
                "Since 2022",
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
              inputField("First Name", firstNameController),
              SizedBox(
                height: 10,
              ),
              inputField("Last Name", lastNameController),
              SizedBox(
                height: 10,
              ),
              inputField("Phone Number", phoneNumberController),
              SizedBox(
                height: 10,
              ),
              inputField("Email", emailController),
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
                      child: DateTimeField(
                        decoration: InputDecoration(
                            border: InputBorder.none, labelText: "Birth Date"),
                        firstDate: DateTime.parse("1940-01-01"),
                        lastDate: DateTime.parse("2005-01-01"),
                        dateFormat: dateFormat,
                        selectedDate: birthdateController,
                        mode: DateTimeFieldPickerMode.date,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            birthdateController = value;
                          });
                        },
                      ),
                    ),
                  )),
              gender,
              inputField("Password", passwordController, obscureText: true),
              SizedBox(
                height: 10,
              ),
              inputField("Confirm Password", confirmPasswordController,
                  obscureText: true),
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
        backgroundColor: Color.fromARGB(255, 224, 224, 224),
        body: login ? loginWidget : signUpWidget);
  }
}
