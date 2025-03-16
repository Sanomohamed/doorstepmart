import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SellForm extends StatefulWidget {
  const SellForm({super.key});

  @override
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

  final List<String> _categories = ['Electronics', 'Clothing', 'Home', 'Books', 'Beverage'];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.length <= 5) {
      setState(() {
        _selectedImages = pickedFiles;
      });
    } else {
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
          'imageUrls': imageUrls,
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
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 40,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Image Picker with GridView
                const Text(
                  "Select Images (Max: 5)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _selectedImages.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(_selectedImages[index].path), fit: BoxFit.cover),
                          );
                        },
                      )
                    : ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: const Text("Pick Images", style: TextStyle(color: Color.fromARGB(255, 29, 28, 28))),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                          backgroundColor: const Color.fromARGB(255, 140, 209, 143),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                const SizedBox(height: 20),

                // ✅ Product Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    prefixIcon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter product name" : null,
                ),

                const SizedBox(height: 16),

                // ✅ Price Field
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter price" : null,
                ),

                const SizedBox(height: 16),

                // ✅ Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter description" : null,
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                // ✅ Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(),
                  ),
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

                // ✅ Upload Button with Loading Indicator
                _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _uploadProduct,
                        icon: const Icon(Icons.upload, color: Colors.white),
                        label: const Text("Upload Product"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
