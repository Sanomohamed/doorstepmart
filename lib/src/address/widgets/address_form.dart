import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? existingData;
  final bool isLoading;
  final Function(Map<String, dynamic>) onSave;

  const AddressForm({
    super.key,
    required this.isEditing,
    this.existingData,
    required this.isLoading,
    required this.onSave,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _fullNameController.text = widget.existingData!['fullName'] ?? '';
      _phoneController.text = widget.existingData!['phone'] ?? '';
      _streetController.text = widget.existingData!['street'] ?? '';
      _cityController.text = widget.existingData!['city'] ?? '';
      _stateController.text = widget.existingData!['state'] ?? '';
      _postcodeController.text = widget.existingData!['Post code'] ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final addressData = {
      'fullName': _fullNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'street': _streetController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'Post code': _postcodeController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    widget.onSave(addressData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextField(_fullNameController, "Full Name"),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, "Phone", keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_streetController, "Street"),
            const SizedBox(height: 16),
            _buildTextField(_cityController, "City"),
            const SizedBox(height: 16),
            _buildTextField(_stateController, "State"),
            const SizedBox(height: 30),
            _buildTextField(_postcodeController, "Post code", keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.isEditing ? "Update Address" : "Save Address", style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
    );
  }
}
//need to modularize this code to make it more readable and maintainable.
// This can be done by breaking down the widget into smaller widgets or methods.