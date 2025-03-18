import 'package:doorstepmart/services/profile_service.dart';
import 'package:doorstepmart/src/sell/sell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/src/profile/validators.dart';
import 'dart:io';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _profileImageUrl;
  bool _isLoading = true;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userData = await fetchUserData(user.uid);
        setState(() {
          _nameController.text = userData['displayName'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';

          // Ensure a valid profile image URL
          String? fetchedImageUrl = userData['profileImageUrl'];
          if (fetchedImageUrl != null && fetchedImageUrl.isNotEmpty) {
            _profileImageUrl = fetchedImageUrl;
          } else {
            _profileImageUrl = null; // Use a local placeholder instead
          }
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? newProfileImageUrl = _profileImageUrl;

      if (_pickedImage != null) {
        newProfileImageUrl = await uploadProfileImage(_pickedImage!);
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      Map<String, dynamic> userData = {
        'email': _emailController.text.trim(),
        'displayName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'profileImageUrl': newProfileImageUrl ?? _profileImageUrl,
      };

      await saveUserData(user.uid, userData);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving profile')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator()) // Show loading indicator
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ✅ Profile Picture with Floating Edit Button
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (_profileImageUrl != null
                                      ? CachedNetworkImageProvider(_profileImageUrl!)
                                      : const AssetImage('assets/default_avatar.png') as ImageProvider),
                            ),
                          ),
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.green,
                            // ignore: sort_child_properties_last
                            child: const Icon(Icons.edit, size: 20, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // ✅ Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration("Name", Icons.person),
                        validator: validateName,
                      ),

                      const SizedBox(height: 20),

                      // ✅ Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration("Email", Icons.email),
                        validator: validateEmail,
                      ),

                      const SizedBox(height: 20),

                      // ✅ Phone Field
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration("Phone", Icons.phone),
                        validator: validatePhone,
                      ),

                      const SizedBox(height: 30),

                      // ✅ Save Button (Improved)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveUserProfile,
                        style: _buttonStyle(Colors.green),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),

                      const SizedBox(height: 15),

                      // ✅ Sell Button (Improved)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SellPage()),
                          );
                        },
                        style: _buttonStyle(Colors.black),
                        child: const Text('Sell', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // ✅ Modern Input Field Styling
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  // ✅ Modern Button Style
  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
    );
  }
}
