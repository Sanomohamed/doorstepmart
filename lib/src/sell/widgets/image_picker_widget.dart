import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; //importing the necessary packages and files
import 'package:fluttertoast/fluttertoast.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<String> existingImageUrls;
  final Function(List<String>) onImageSelected;

  const ImagePickerWidget({super.key, required this.existingImageUrls, required this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  // An instance of ImagePicker to pick images from the device.
  List<String> _selectedImagePaths = [];
  // A list to store the paths of the selected images.

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.length <= 5) {
      setState(() {
        _selectedImagePaths = pickedFiles.map((file) => file.path).toList();
        widget.onImageSelected(_selectedImagePaths);
      });
    } else {
      Fluttertoast.showToast(msg: "You can select up to 5 images only");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Images (Max: 5)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: widget.existingImageUrls.length + _selectedImagePaths.length,
          itemBuilder: (context, index) {
            if (index < widget.existingImageUrls.length) {
              return Image.network(widget.existingImageUrls[index], fit: BoxFit.cover);
            } else {
              return Image.file(File(_selectedImagePaths[index - widget.existingImageUrls.length]), fit: BoxFit.cover);
            }
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.image, color: Colors.white),
          label: const Text("Pick Images", style: TextStyle(color: Colors.black)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}
