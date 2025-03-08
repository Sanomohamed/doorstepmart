import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final List<XFile> selectedImages;

  const ImagePickerWidget({super.key, required this.selectedImages});

  @override
  Widget build(BuildContext context) {
    return selectedImages.isEmpty
        ? const Text("No images selected")
        : Wrap(
            spacing: 8,
            children: selectedImages
                .map((image) => Image.file(File(image.path), width: 100, height: 100, fit: BoxFit.cover))
                .toList(),
          );
  }
}