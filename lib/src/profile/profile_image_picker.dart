import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? pickedImage;
  final String? imageUrl;
  final VoidCallback onEdit;

  const ProfileImagePicker({
    super.key,
    required this.pickedImage,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = pickedImage != null
        ? FileImage(pickedImage!)
        : (imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImageProvider(imageUrl!)
            : const AssetImage('assets/default_avatar.png') as ImageProvider);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: imageProvider,
        ),
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.green,
          onPressed: onEdit,
          child: const Icon(Icons.edit, size: 20, color: Colors.white),
        ),
      ],
    );
  }
}
