import 'package:flutter/material.dart';
//importing the necessary packages and files

class ProductFormFields extends StatelessWidget {
 // This widget is used to create the form fields for adding a product
  // It includes fields for product name, price, description, and category selection.
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String? selectedCategory;
  // The selected category for the product
  // This is a nullable string that can be null if no category is selected.
  final List<String> categories;
  // A list of categories to choose from
  // This is a list of strings that represent the available categories for the product.
  final Function(String?) onCategoryChanged;
  // A callback function that is called when the category is changed
  // This function takes a nullable string as an argument and returns void.

  const ProductFormFields({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(nameController, "Product Name", Icons.label),
        const SizedBox(height: 16),
        _buildTextField(priceController, "Price", Icons.attach_money, isNumeric: true),
        const SizedBox(height: 16),
        _buildTextField(descriptionController, "Description", Icons.description, maxLines: 3),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          // This widget is used to create a dropdown menu for selecting a category
          value: selectedCategory,
          decoration: const InputDecoration(labelText: "Select Category", border: OutlineInputBorder()),
          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: onCategoryChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false, int maxLines = 1}) {
    // This method is used to create a text field with the specified parameters
    // It takes a controller, label, icon, and optional parameters for numeric input and max lines.
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      // This sets the keyboard type to numeric if isNumeric is true, otherwise it uses text input.
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      // This validates the input and returns an error message if the field is empty.
      maxLines: maxLines,
    );
  }
}
