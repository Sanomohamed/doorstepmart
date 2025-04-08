import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:doorstepmart/services/profile_service.dart';
import 'package:doorstepmart/src/profile/widgets/validators.dart';
import 'package:doorstepmart/src/sell/sell.dart';

// Modularized widgets
import 'package:doorstepmart/src/profile/widgets/profile_image_editor.dart';
import 'package:doorstepmart/src/profile/widgets/profile_text_field.dart';
import 'package:doorstepmart/src/profile/widgets/profile_action_button.dart';
import 'package:doorstepmart/src/profile/widgets/profile_update_dialog.dart';
import 'package:doorstepmart/src/profile/widgets/profile_confirmation_snackbar.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _profileImageUrl;
  File? _pickedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await fetchUserData(user.uid);
        _nameController.text = userData['displayName'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phoneNumber'] ?? '';
        _profileImageUrl = userData['profileImageUrl'];

        // Autofill from Google Sign-In
        if (user.providerData.any((info) => info.providerId == 'google.com')) {
          _autofillFromGoogle(user);
        }
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _autofillFromGoogle(User user) {
    setState(() {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      _profileImageUrl = user.photoURL;
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _confirmBeforeUpdate() {
    showConfirmationSnackbar(
      context: context,
      onConfirmed: _showUploadProgressAndSave,
    );
  }

  void _showUploadProgressAndSave() async {
    showUploadProgressDialog(context);
    await _saveUserProfile();
    if (mounted) Navigator.of(context).pop(); // Close the dialog
  }

  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final profileUrl = _pickedImage != null
          ? await uploadProfileImage(_pickedImage!)
          : _profileImageUrl;

      final updatedData = {
        'email': _emailController.text.trim(),
        'displayName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'profileImageUrl': profileUrl,
      };

      await saveUserData(user.uid, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProfileImageEditor(
                            pickedImage: _pickedImage,
                            profileImageUrl: _profileImageUrl,
                            onPickImage: _pickImage,
                          ),
                          const SizedBox(height: 25),
                          ProfileTextField(
                            controller: _nameController,
                            label: "Name",
                            icon: Icons.person,
                            validator: validateName,
                          ),
                          const SizedBox(height: 20),
                          ProfileTextField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                            validator: validateEmail,
                          ),
                          const SizedBox(height: 20),
                          ProfileTextField(
                            controller: _phoneController,
                            label: "Phone",
                            icon: Icons.phone,
                            validator: validatePhone,
                          ),
                          const SizedBox(height: 30),
                          ProfileActionButton(
                            label: 'Save',
                            color: Colors.green,
                            onPressed: _confirmBeforeUpdate,
                          ),
                          const SizedBox(height: 15),
                          ProfileActionButton(
                            label: 'Sell',
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SellPage(editProduct: {}, productData: null, productId: null),
                                ),
                              );
                            },
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

//try break the code into smaller widgets and functions to improve readability and maintainability.
