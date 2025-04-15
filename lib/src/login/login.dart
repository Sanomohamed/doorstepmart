import 'package:doorstepmart/src/login/loginform.dart';
import 'package:doorstepmart/src/login/signup_prompt.dart';
import 'package:flutter/material.dart';
import 'login_image.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
              children: const <Widget>[
                LoginImage(),
                SizedBox(height: 16),
                LoginForm(),
                SignupPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}