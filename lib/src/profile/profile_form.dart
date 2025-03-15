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
  bool _isLoading = true; // Show loading indicator when fetching data
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

          // Ensure a valid profile image URL is used
          String? fetchedImageUrl = userData['profileImageUrl'];
          if (fetchedImageUrl != null &&
              fetchedImageUrl.isNotEmpty &&
              !fetchedImageUrl.contains("via.placeholder.com")) {
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
        print('New Profile Image URL: $newProfileImageUrl');
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Error: User is not logged in.');
        return;
      }

      Map<String, dynamic> userData = {
        'email': _emailController.text.trim(),
        'displayName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'profileImageUrl': newProfileImageUrl ?? _profileImageUrl,
      };

      await saveUserData(user.uid, userData);
      print('User profile updated successfully!');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      print('Error saving user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving profile')),
        );
      }
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
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : (_profileImageUrl != null
                            ? CachedNetworkImageProvider(_profileImageUrl!)
                            : const AssetImage('assets/default_avatar.png') as ImageProvider),
                    child: _pickedImage == null && _profileImageUrl == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: validateName,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: validateEmail,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: validatePhone,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveUserProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SellPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Sell'),
                ),
              ],
            ),
          );
  }
}
