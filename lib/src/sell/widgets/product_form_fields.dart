import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onCategoryChanged;

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
          value: selectedCategory,
          decoration: const InputDecoration(labelText: "Select Category", border: OutlineInputBorder()),
          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: onCategoryChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      maxLines: maxLines,
    );
  }
}
