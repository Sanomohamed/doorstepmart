// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/address/address_form.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';    // ← import CartModel
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                  // ← import Provider

class AddEditAddressPage extends StatefulWidget {
  final String? addressId; // null = new address
  final Map<String, dynamic>? existingData;

  const AddEditAddressPage({
    super.key,
    this.addressId,
    this.existingData,
  });

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

  Future<void> _saveAddress(Map<String, dynamic> addressData) async {
    setState(() => _isLoading = true);

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses');

    try {
      if (widget.addressId != null) {
        // Update existing
        await ref.doc(widget.addressId).update(addressData);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Address updated")));
      } else {
        // Add new
        final newDoc = await ref.add(addressData);
        // if you want the generated ID in your stored map:
        addressData['id'] = newDoc.id;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Address added")));
      }

      // ← NEW: if this address is default, persist into CartModel
      if (addressData['isDefault'] == true) {
        Provider.of<CartModel>(context, listen: false)
            .setSelectedAddress(addressData);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error saving address: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving address")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.addressId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Address" : "Add Address"),
        backgroundColor: Colors.green,
      ),
      body: AddressForm(
        isEditing: isEditing,
        existingData: widget.existingData,
        isLoading: _isLoading,
        onSave: _saveAddress,
      ),
    );
  }
}
