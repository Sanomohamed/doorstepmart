import 'package:doorstepmart/src/account/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/profile/profile.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
    _controller.fetchUserEmail(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // ✅ Profile Avatar with Edit Button
                Stack(
                  children: [
                    _buildProfileAvatar(),
                    _buildEditIcon(context),
                  ],
                ),
                const SizedBox(width: 16.0),

                // ✅ User Details Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _controller.username,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _controller.email ?? 'Email not available',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),

            // ✅ Settings Button
            IconButton(
              icon: const Icon(Icons.settings, size: 28, color: Colors.black54),
              onPressed: () {
                // Handle settings action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: const CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 40, color: Colors.black54),
      ),
    );
  }

  Widget _buildEditIcon(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.edit, size: 15, color: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
//break down into multiple widgets
