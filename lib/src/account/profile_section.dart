import 'package:doorstepmart/src/account/profile/profile_avatar_edit.dart';
import 'package:doorstepmart/src/account/profile/settings_button.dart';
import 'package:doorstepmart/src/account/profile/user_details.dart';
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
                ProfileAvatarWithEdit(onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                }),
                const SizedBox(width: 16.0),
                UserDetails(
                  username: _controller.username,
                  email: _controller.email ?? 'Email not available',
                ),
              ],
            ),
            const SettingsButton(),
          ],
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
