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
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.all(45),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ✅ Profile Picture Section with Overlay
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 99,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : (_profileImageUrl != null
                                    ? CachedNetworkImageProvider(_profileImageUrl!)
                                    : const AssetImage('assets/default_avatar.png') as ImageProvider),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color.fromARGB(249, 111, 212, 114),
                              child: IconButton(
                                icon: const Icon(Icons.edit, size: 24, color: Colors.white),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      // ✅ Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: validateName,
                      ),

                      const SizedBox(height: 35),

                      // ✅ Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: validateEmail,
                      ),

                      const SizedBox(height: 35),

                      // ✅ Phone Field
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: validatePhone,
                      ),

                      const SizedBox(height: 30),

                      // ✅ Save Button
          ElevatedButton(
                   onPressed: _isLoading ? null : _saveUserProfile, // Disable button when loading
               style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(115, 76, 175, 79),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 90), // ✅ Increased size
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18), // ✅ More rounded corners
                   ),
                         elevation: 25, // ✅ Soft shadow for a modern touch
                ),
                      child: _isLoading
               ? const SizedBox(
                      width: 24,
                     height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
          ),
        )
               : const Text(
                          'Save',
                  style: TextStyle(
                          fontSize: 26, // ✅ Bigger font size
                         fontWeight: FontWeight.bold,
                         letterSpacing: 1.2, // ✅ Spaced-out text for readability
                            ),
                            ),
                          ),

                      const SizedBox(height: 20),

                      // ✅ Sell Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SellPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Sell', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
