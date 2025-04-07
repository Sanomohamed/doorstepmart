import 'package:doorstepmart/src/sell/image_picker_widget.dart';
import 'package:doorstepmart/src/sell/product_actions.dart';
import 'package:doorstepmart/src/sell/product_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SellForm extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String? productId;

  const SellForm({super.key, this.productData, this.productId});

  @override
  _SellFormState createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isUploading = false;
  List<String> _existingImageUrls = [];
  List<String> _selectedImagePaths = [];
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

  @override
@override
Widget build(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Image Picker
                  ImagePickerWidget(
                    existingImageUrls: _existingImageUrls,
                    onImageSelected: (paths) => setState(() => _selectedImagePaths = paths),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Form Fields
                  ProductFormFields(
                    nameController: _nameController,
                    priceController: _priceController,
                    descriptionController: _descriptionController,
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onCategoryChanged: (value) => setState(() => _selectedCategory = value),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Save/Upload Buttons
                  ProductActions(
                    formKey: _formKey,
                    isUploading: _isUploading,
                    productId: widget.productId,
                    productData: {
                      'name': _nameController.text.trim(),
                      'price': _priceController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'category': _selectedCategory,
                      'imagePaths': _selectedImagePaths,
                      'existingImages': _existingImageUrls,
                    },
                    onUploadStart: () => setState(() => _isUploading = true),
                    onUploadEnd: () => setState(() => _isUploading = false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}
//try to break the code into smaller widgets to improve readability and maintainability
