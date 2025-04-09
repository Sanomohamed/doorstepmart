import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddEditAddressPage extends StatefulWidget {
  final String? addressId; // null = new address
  final Map<String, dynamic>? existingData;

  const AddEditAddressPage({super.key, this.addressId, this.existingData});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
    final _postcodeController = TextEditingController();

  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

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

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final addressData = {
      'fullName': _fullNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'street': _streetController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'Post code': _postcodeController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses');

    try {
      if (widget.addressId != null) {
        // Update
        await ref.doc(widget.addressId).update(addressData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address updated")));
      } else {
        // Add new
        await ref.add(addressData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address added")));
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print("Error saving address: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error saving address")));
    } finally {
      setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.addressId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Address" : "Add Address"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
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
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? "Update Address" : "Save Address", style: const TextStyle(fontSize: 18)),
              )
            ],
          ),
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
