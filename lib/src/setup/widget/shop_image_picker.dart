import 'dart:io';
import 'package:flutter/material.dart';
/// importing the necessary packages and files

class ShopImagePicker extends StatelessWidget {
  /// This widget is used to pick an image for the shop profile
  final File? pickedImage;
  /// The pickedImage is a File object that represents the image file.
  /// It is nullable, meaning it can be null if no image has been picked yet.
  final VoidCallback onPick;
  /// The onPick is a callback function that will be called when the user taps on the image picker.
  /// It is used to trigger the image picking process.

  const ShopImagePicker({super.key, this.pickedImage, required this.onPick, File? image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: CircleAvatar(
        /// CircleAvatar is a widget that displays a circular image.
        /// It is used to show the profile picture of the shop.
        radius: 60,
        backgroundImage: pickedImage != null
            ? FileImage(pickedImage!)
            /// FileImage is used to display an image from a file.
            /// It takes the pickedImage as a parameter.
            : const AssetImage('assets/profile.png') as ImageProvider,
        /// AssetImage is used to display an image from the assets folder.
        /// It takes the path of the image as a parameter.
        child: pickedImage == null
            /// If no image is picked, it shows a camera icon.
            /// The icon is displayed in the center of the CircleAvatar.
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
            /// If an image is picked, it shows the image.
            /// The image is displayed in the CircleAvatar.
            : null,
      ),
    );
  }
}
