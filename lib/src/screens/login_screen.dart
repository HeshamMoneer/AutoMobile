import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/repository/errorhandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool newUserMode = false;

  void toggleMode() {
    setState(() {
      newUserMode = !newUserMode;
    });
  }

  void loginORsignup() async {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    try {
      if (newUserMode) {
        if (passwordController.text == confirmPasswordController.text) {
          try {
            var result = await allProvider.repository.fireBaseHandler
                .signup(emailController.text, passwordController.text);
          } catch (e) {
            throw ErrorHandler(e.toString());
          }
        } else {
          throw ErrorHandler("The passwords do not match");
        }
      } else {
        var result = await allProvider.repository.fireBaseHandler
            .login(emailController.text, passwordController.text);
      }
      //TODO: this code executes even if an error is thrown
      Navigator.of(context).pushReplacementNamed('/mainscreen');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 400,
        margin: EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "AutoMobile",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Password"),
                  controller: passwordController,
                  obscureText: true,
                ),
                if (newUserMode)
                  TextField(
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    controller: confirmPasswordController,
                    obscureText: true,
                  ),
                ElevatedButton(
                  onPressed: () {
                    loginORsignup();
                  },
                  child: newUserMode ? Text("Sign up") : Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    toggleMode();
                  },
                  child: newUserMode
                      ? Text("Login instead")
                      : Text("Sign up instead"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
