// ignore: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doorstepmart/src/profile/profile.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final TextEditingController _usernameController = TextEditingController();
  String? _email;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _email = user.email;
          _usernameController.text = user.displayName ?? 'Username'; // Replace with actual username if available
        });
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: const Icon(Icons.person, size: 40), // Icon used instead of image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 15),
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                        // Handle edit profile action
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  _email ?? 'Email not available',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Handle settings action
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}