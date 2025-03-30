import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileController {
  final TextEditingController usernameController = TextEditingController();
  String? email;

  String get username => usernameController.text;

  void fetchUserEmail(Function setStateCallback) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        email = user.email;
        usernameController.text = user.displayName ?? 'Username'; // Default if display name is null
        setStateCallback(() {}); // Notify UI to update
      }
    } catch (e) {
      debugPrint('Error fetching user email: $e');
    }
  }

  void dispose() {
    usernameController.dispose();
  }
}
