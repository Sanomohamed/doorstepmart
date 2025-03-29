import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/setup/create_shop_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SellForm extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String? productId;

  const SellForm({super.key, this.productData, this.productId});

  @override
  // ignore: library_private_types_in_public_api
  _SellFormState createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final _formKey = GlobalKey<FormState>();
  List<XFile> _selectedImages = [];
  List<String> _existingImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isUploading = false;

  final List<String> _categories = ['Drinks', 'Fruits', 'Poultry', 'Vegetable', 'Rice'];

  @override
  void initState() {
    super.initState();
    if (widget.productData != null) {
      _populateForm(widget.productData!);
    }
  }

  void _populateForm(Map<String, dynamic> data) {
    _nameController.text = data['name'] ?? '';
    _priceController.text = data['price'].toString();
    _descriptionController.text = data['description'] ?? '';
    _selectedCategory = data['category'];
    if (data['imageUrls'] != null && data['imageUrls'] is List) {
      _existingImageUrls = List<String>.from(data['imageUrls']);
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.length <= 5) {
      setState(() => _selectedImages = pickedFiles);
    } else {
      Fluttertoast.showToast(msg: "You can select up to 5 images only");
    }
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and select images.");
      return;
    }
    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final shopSnapshot = await FirebaseFirestore.instance
          .collection("shops")
          .where("userId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnapshot.docs.isEmpty) {
        Fluttertoast.showToast(msg: "You need to create a shop first.");
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateShopPage()));
        return;
      }

      final shopData = shopSnapshot.docs.first.data();
      final shopId = shopSnapshot.docs.first.id;
      final shopName = shopData['shopName'] ?? 'Shop';

      List<String> imageUrls = [..._existingImageUrls];
      for (var image in _selectedImages) {
        File file = File(image.path);
        String fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      final productData = {
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'imageUrls': imageUrls,
        'shopId': shopId,
        'shopName': shopName,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (widget.productId != null) {
        await FirebaseFirestore.instance.collection('products').doc(widget.productId).update(productData);
        Fluttertoast.showToast(msg: "Product updated successfully");
      } else {
        await FirebaseFirestore.instance.collection('products').add(productData);
        Fluttertoast.showToast(msg: "Product uploaded successfully");
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // 🔄 Refresh grid
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _deleteProduct() async {
    if (widget.productId != null) {
      await FirebaseFirestore.instance.collection('products').doc(widget.productId).delete();
      Fluttertoast.showToast(msg: "Product deleted successfully");
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // 🔄 Refresh grid
    }
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
                  itemCount: _selectedImages.length + _existingImageUrls.length,
                  itemBuilder: (context, index) {
                    if (index < _existingImageUrls.length) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(_existingImageUrls[index], fit: BoxFit.cover),
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(_selectedImages[index - _existingImageUrls.length].path), fit: BoxFit.cover),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text("Pick Images"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(height: 20),
                _buildTextField(_nameController, "Product Name", Icons.label),
                const SizedBox(height: 16),
                _buildTextField(_priceController, "Price", Icons.attach_money, isNumeric: true),
                const SizedBox(height: 16),
                _buildTextField(_descriptionController, "Description", Icons.description, maxLines: 3),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: "Select Category", border: OutlineInputBorder()),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  validator: (value) => value == null ? "Select a category" : null,
                ),
                const SizedBox(height: 20),
                _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _uploadProduct,
                            icon: const Icon(Icons.upload),
                            label: Text(widget.productId != null ? "Update Product" : "Upload Product"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),
                          if (widget.productId != null) ...[
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: _deleteProduct,
                              icon: const Icon(Icons.delete),
                              label: const Text("Delete Product"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                          ]
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      maxLines: maxLines,
    );
  }
}
