import 'package:doorstepmart/src/login/login.dart';
import 'package:doorstepmart/src/login/login_image.dart';
import 'package:doorstepmart/src/signup/signupform.dart';
import 'package:flutter/material.dart';
//importing the necessary packages

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    // It is a stateless widget that builds the signup screen.
    return Scaffold(
      backgroundColor: const Color(0xFFD2DBD6),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            ///containing the signup page elements 
            /// including the image and the signup form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const LoginImage(),
                const SizedBox(height: 5),
                const SignupForm(),
                const SizedBox(height: 15),
                /// A button to navigate to the login page if the user already has an account
                /// It contains a text and a button to navigate to the login page
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 27, 27, 27),
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color.fromARGB(230, 12, 12, 12),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}