import 'package:doorstepmart/src/login/login.dart';
import 'package:doorstepmart/src/login/login_image.dart';
import 'package:doorstepmart/src/signup/signupform.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/login/forgetpassword.dart';
import 'package:doorstepmart/src/login/social_loginbuttons.dart';


class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2DBD6),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const LoginImage(),
                const SizedBox(height: 16),
                const SignupForm(),
                const SizedBox(height: 10),
                const ForgotPassword(),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
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
                        "Sign in",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SocialLoginButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}