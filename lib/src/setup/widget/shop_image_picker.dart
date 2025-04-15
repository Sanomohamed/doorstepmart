import 'dart:io';
import 'package:flutter/material.dart';

class ShopImagePicker extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onPick;

  const ShopImagePicker({super.key, this.pickedImage, required this.onPick, File? image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: CircleAvatar(
        radius: 60,
        backgroundImage: pickedImage != null
            ? FileImage(pickedImage!)
            : const AssetImage('assets/profile.png') as ImageProvider,
        child: pickedImage == null
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
            : null,
      ),
    );
  }
}
