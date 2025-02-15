import 'package:flutter/material.dart';
import 'package:doorstepmart/src/profile/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: const Color.fromARGB(255, 137, 185, 138),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
       backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProfileForm(),
      ),
    );
  }
}