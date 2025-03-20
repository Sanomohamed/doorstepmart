import 'dart:io';
import 'package:doorstepmart/src/setup/createshoppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final List<String> _categories = ['Electronics', 'Clothing', 'Home', 'Books', 'Beverage'];

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
    if (!_formKey.currentState!.validate() || _selectedImages.isEmpty || _selectedCategory == null) {
      _showDialog('Error', 'Please fill all fields and select images.');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // ✅ Fetch User's Shop Information Safely
      QuerySnapshot shopSnapshot = await FirebaseFirestore.instance
          .collection("shops")
          .where("userId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnapshot.docs.isEmpty) {
        setState(() => _isUploading = false);
        _showDialog('Error', 'You need to create a shop before uploading products.');
        return;
      }

      // ✅ Extract Shop Data Safely
      var shopDoc = shopSnapshot.docs.first;
      var shopData = shopDoc.data() as Map<String, dynamic>? ?? {};
      String shopId = shopDoc.id;
      String shopName = shopData['shopName']?.toString().trim() ?? "No Shop Name"; 

      debugPrint("✅ Shop ID: $shopId | ✅ Shop Name: $shopName");

      // ✅ Upload Images to Firebase Storage
      List<String> imageUrls = [];
      for (var image in _selectedImages) {
        File file = File(image.path);
        String fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";

        UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // ✅ Upload Product to Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'imageUrls': imageUrls,
        'shopId': shopId,
        'shopName': shopName,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      debugPrint("✅ Product Uploaded Successfully with Shop Name: $shopName");

      _showDialog('Success', 'Product uploaded successfully!');
      _resetForm();
    } catch (e) {
      _showDialog('Error', 'Error uploading product: $e');
      debugPrint("🔥 Upload Error: $e");
    }

    setState(() {
      _isUploading = false;
    });
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
                if (message == 'You need to create a shop before uploading products.') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateShopPage()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 20,
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
                        label: const Text("Pick Images", style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                const SizedBox(height: 20),

                _buildTextField(_nameController, "Product Name", Icons.label),
                const SizedBox(height: 16),
                _buildTextField(_priceController, "Price", Icons.attach_money, isNumeric: true),
                const SizedBox(height: 16),
                _buildTextField(_descriptionController, "Description", Icons.description, maxLines: 3),
                const SizedBox(height: 16),

                // ✅ Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: "Select Category", border: OutlineInputBorder()),
                  items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  validator: (value) => value == null ? "Select a category" : null,
                ),
                const SizedBox(height: 20),

                _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _uploadProduct,
                        icon: const Icon(Icons.upload, color: Colors.white),
                        label: const Text("Upload Product"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
