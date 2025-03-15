import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SellForm extends StatefulWidget {
  const SellForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SellFormState createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final _formKey = GlobalKey<FormState>();
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isUploading = false;

  final List<String> _categories = ['Electronics', 'Clothing', 'Home', 'Books','Beverage'];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.length <= 5) {
      setState(() {
        _selectedImages = pickedFiles;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can select up to 5 images only")),
      );
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate() &&
        _selectedImages.isNotEmpty &&
        _selectedCategory != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        List<String> imageUrls = [];

        for (var image in _selectedImages) {
          File file = File(image.path);
          String fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";

          UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(file);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }

        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'category': _selectedCategory,
          'imageUrls': imageUrls, // ✅ Ensure images are stored as a list
          'timestamp': FieldValue.serverTimestamp(),
        });

        _showDialog('Success', 'Product uploaded successfully!');
        _resetForm();
      } catch (e) {
        _showDialog('Error', 'Error uploading product: $e');
      }

      setState(() {
        _isUploading = false;
      });
    } else {
      _showDialog('Error', 'Please fill all fields and select images.');
    }
  }

  void _resetForm() {
    setState(() {
      _selectedImages = [];
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Images (Max: 5)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: _pickImages, child: const Text("Pick Images")),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
              validator: (value) => value!.isEmpty ? "Enter product name" : null,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Enter price" : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              validator: (value) => value!.isEmpty ? "Enter description" : null,
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Select Category"),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) => value == null ? "Select a category" : null,
            ),
            const SizedBox(height: 20),
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _uploadProduct,
                    child: const Text("Upload Product"),
                  ),
          ],
        ),
      ),
    );
  }
}
