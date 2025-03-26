import 'package:flutter/material.dart';
import 'package:doorstepmart/src/profile/validators.dart';
import 'profile_styles.dart';

class ProfileFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const ProfileFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        TextFormField(
          controller: nameController,
          decoration: inputDecoration("Name", Icons.person),
          validator: validateName,
        ),
        const SizedBox(height: 40),
        TextFormField(
          controller: emailController,
          decoration: inputDecoration("Email", Icons.email),
          validator: validateEmail,
        ),
        const SizedBox(height: 40),
        TextFormField(
          controller: phoneController,
          decoration: inputDecoration("Phone", Icons.phone),
          validator: validatePhone,
        ),
      ],
    );
  }
}
