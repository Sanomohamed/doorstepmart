import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/address/widgets/customtext.dart';
import 'package:doorstepmart/src/address/widgets/submitbutton.dart';
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
            CustomTextField(controller: _fullNameController, label: "Full Name"),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              label: "Phone",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _streetController, label: "Street"),
            const SizedBox(height: 16),
            CustomTextField(controller: _cityController, label: "City"),
            const SizedBox(height: 16),
            CustomTextField(controller: _stateController, label: "State"),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _postcodeController,
              label: "Post code",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SubmitButton(
              isLoading: widget.isLoading,
              isEditing: widget.isEditing,
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}