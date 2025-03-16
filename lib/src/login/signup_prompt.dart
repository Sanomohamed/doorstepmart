import 'package:doorstepmart/src/signup/signup.dart';
import 'package:flutter/material.dart';
class SignupPrompt extends StatelessWidget {
  const SignupPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
             TextButton(
              onPressed: () {
                // Add your onPressed code here!
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 65, 65),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}