import 'package:flutter/material.dart';
import 'package:doorstepmart/src/sell/widgets/image_picker_widget.dart';
import 'package:doorstepmart/src/sell/widgets/product_form_fields.dart';     //importing necessary packages and files
import 'package:doorstepmart/src/sell/widgets/confirm_upload_actions.dart';

class SellForm extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String? productId;

  const SellForm({super.key, this.productData, this.productId});

  @override
  State<SellForm> createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _existingImageUrls = [];
  List<String> _selectedImagePaths = [];
  bool _isUploading = false;

  final List<String> _categories = ['Drinks', 'Fruits', 'Poultry', 'Vegetable', 'Rice'];

  @override
  void initState() {
    super.initState();
    if (widget.productData != null) _populateForm(widget.productData!);    // If product data is provided, populate the form with existing data
  }
  
// This method populates the form fields with existing product data
  void _populateForm(Map<String, dynamic> data) {
    _nameController.text = data['name'] ?? '';
    _priceController.text = data['price'].toString();
    _descriptionController.text = data['description'] ?? '';
    _selectedCategory = data['category'];
    _existingImageUrls = List<String>.from(data['imageUrls'] ?? []);
  }

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
                  children: [
// This widget allows users to select images for the product                    
                    ImagePickerWidget(
                      existingImageUrls: _existingImageUrls,
                      onImageSelected: (paths) => setState(() => _selectedImagePaths = paths),
                    ),
                    const SizedBox(height: 20),
 // This widget contains the form fields for product details                    
                    ProductFormFields(
                      nameController: _nameController,
                      priceController: _priceController,
                      descriptionController: _descriptionController,
                      selectedCategory: _selectedCategory,
                      categories: _categories,
                      onCategoryChanged: (val) => setState(() => _selectedCategory = val),
                    ),
                    const SizedBox(height: 20),
 // This widget contains the buttons for confirming or canceling the upload                    
                    ConfirmUploadActions(
                      formKey: _formKey,
                      isUploading: _isUploading,
                      productId: widget.productId,
                      getProductData: () => {
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
