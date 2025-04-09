import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
//importing the necessary packages and files

class ImagePickerWidget extends StatefulWidget {
  /// A widget that allows users to pick images from their device.
  final List<String> existingImageUrls;
  /// A list of existing image URLs to display.
  /// This is used to show the images that have already been selected or uploaded.
  final Function(List<String>) onImageSelected;
  /// A callback function that is called when images are selected.

  const ImagePickerWidget({super.key, required this.existingImageUrls, required this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  /// The state of the ImagePickerWidget.
  /// This class manages the state of the image picker widget, including the selected images.
  final ImagePicker _picker = ImagePicker();
  /// An instance of ImagePicker to pick images from the device.
  List<String> _selectedImagePaths = [];
  /// A list to store the paths of the selected images.

  Future<void> _pickImages() async {
    /// A method to pick images from the device.
    final pickedFiles = await _picker.pickMultiImage();
    /// This method uses the ImagePicker to allow the user to select multiple images.
    if (pickedFiles != null && pickedFiles.length <= 5) {
      /// If the user selects images, it checks if the number of selected images is less than or equal to 5.
      setState(() {
        /// If the condition is met, it updates the _selectedImagePaths list with the paths of the selected images.
        /// It also calls the onImageSelected callback function to pass the selected image paths to the parent widget.
        _selectedImagePaths = pickedFiles.map((file) => file.path).toList();
        widget.onImageSelected(_selectedImagePaths);
      });
    } else {
      Fluttertoast.showToast(msg: "You can select up to 5 images only");
    }
  }

  @override
  Widget build(BuildContext context) {
    /// The build method of the widget.
    /// It returns a Column widget that contains the image picker UI.
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
          /// The total number of items in the grid is the sum of existing image URLs and selected image paths.
          /// This allows the grid to display both existing images and newly selected images.
          itemBuilder: (context, index) {
            /// The itemBuilder method is used to build each item in the grid.
            if (index < widget.existingImageUrls.length) {
              /// If the index is less than the number of existing image URLs, it displays the existing images.
              /// Otherwise, it displays the newly selected images.
              return Image.network(widget.existingImageUrls[index], fit: BoxFit.cover);
            } else {
              return Image.file(File(_selectedImagePaths[index - widget.existingImageUrls.length]), fit: BoxFit.cover);
            }
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          /// An ElevatedButton with an icon to pick images.
          onPressed: _pickImages,
          /// When the button is pressed, it calls the _pickImages method to allow the user to select images.
          icon: const Icon(Icons.image, color: Colors.white),
          label: const Text("Pick Images"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}
