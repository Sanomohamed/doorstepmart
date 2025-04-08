import 'package:flutter/material.dart';
import 'package:doorstepmart/src/profile/profile_form.dart';
//import 'package:doorstepmart/src/profile/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor:  const Color.fromARGB(192, 210, 219, 214),
        elevation: 3, // ✅ Soft shadow for better visibility
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(192, 210, 219, 214), // Set the background color
        child: const ProfileForm(),
      ),
    );
  }
}
