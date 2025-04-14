// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImageEditor extends StatelessWidget {
  final File? pickedImage;
  final String? profileImageUrl;
  final VoidCallback onPickImage;

  const ProfileImageEditor({
    super.key,
    required this.pickedImage,
    required this.profileImageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundImage: pickedImage != null
                ? FileImage(pickedImage!)
                //if the image is picked, use FileImage to display it
                : (profileImageUrl != null
                   //if the image URL is not null, use CachedNetworkImageProvider to display it
                    ? CachedNetworkImageProvider(profileImageUrl!)
                    : const AssetImage('assets/default_avatar.png')) as ImageProvider,
          ),
        ),
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.green,
          onPressed: onPickImage,
          child: const Icon(Icons.edit, size: 20, color: Colors.white),
        ),
      ],
    );
  }
}
