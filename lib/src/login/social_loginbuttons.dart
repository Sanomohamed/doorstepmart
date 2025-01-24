import 'package:doorstepmart/src/custom_widgets.dart';
import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconButton(
          icon: Icons.login,
         onPressed: ()  {
          },
        ),
        const SizedBox(width: 20),
        CustomIconButton(
          icon: Icons.apple,
          onPressed: () {
            // Add your onPressed code here!
          },
        ),
      ],
    );
  }
}