import 'package:flutter/material.dart';

class ProfileAvatarWithEdit extends StatelessWidget {
  final VoidCallback onEdit;

  const ProfileAvatarWithEdit({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.black54),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.edit, size: 15, color: Colors.green),
              onPressed: onEdit,
            ),
          ),
        ),
      ],
    );
  }
}
