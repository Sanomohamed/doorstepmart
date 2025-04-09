import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//importing the necessary packages for the image editor

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
      //using stack to overlay the image and the edit button
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
            //using circle avatar to display the profile image
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
          //floating action button to edit the image
          mini: true,
          backgroundColor: Colors.green,
          onPressed: onPickImage,
          child: const Icon(Icons.edit, size: 20, color: Colors.white),
        ),
      ],
    );
  }
}
