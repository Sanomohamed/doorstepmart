import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';


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
  File? _profileImage;
  

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch current user data from FirebaseAuth
 // Fetch current user data from FirebaseAuth and Firestore
 Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = userData['displayName'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phoneNumber'] ?? '';
          });

          // Fetch profile image from Firebase Storage
          if (userData['profileImageUrl'] != null) {
            String profileImageUrl = userData['profileImageUrl'];
            File profileImageFile = await _downloadProfileImage(profileImageUrl);
            setState(() {
              _profileImage = profileImageFile;
            });
          }
        } else {
          // Fall back to using data from FirebaseAuth
          setState(() {
            _nameController.text = user.displayName ?? '';
            _emailController.text = user.email ?? '';
            _phoneController.text = user.phoneNumber ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }


  Future<File> _downloadProfileImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/profile_image.jpg');
      await ref.writeToFile(file);
      return file;
    } catch (e) {
      print('Error downloading profile image: $e');
      rethrow;
    }
  }


  // Pick an image for the profile from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }


  // Upload profile image to Firebase Storage
  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow; // Re-throw the error to handle it in the caller function
    }
  }


  // Save the user profile information to Firestore
  Future<void> _saveUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? profileImageUrl;

        // Upload the profile image if there is one selected
        if (_profileImage != null) {
          profileImageUrl = await _uploadProfileImage(_profileImage!);
          print('Profile Image URL: $profileImageUrl');
        }

        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null || user.uid.isEmpty) {
          print('Error: User UID is invalid or user is not logged in.');
          return;
        }

        // Debug: Log the current user information
        print('Current user: ${user.uid}');
        print('User email: ${user.email}');
        print('User displayName: ${user.displayName}');

        // Reference to the user's Firestore document
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Prepare data to save to Firestore
        Map<String, dynamic> userData = {
          'email': _emailController.text.trim(),
          'displayName': _nameController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
        };

        // Add profileImageUrl to the data if it's available
        if (profileImageUrl != null) {
          userData['profileImageUrl'] = profileImageUrl;
        }

        // Debug: Print the data to be saved
        print('User data to be saved: $userData');

        // Write the user data to Firestore with merge (to avoid overwriting existing fields)
        await userRef.set(userData, SetOptions(merge: true));

        print('User profile updated: ${user.uid}');

        // Show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } on FirebaseException catch (e) {
        // Handle Firebase-specific errors
        print('Firebase Error saving user profile: ${e.message}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Firebase Error: ${e.message ?? 'An error occurred'}')),
          );
        }
      } catch (e) {
        // Handle general errors
        print('Error saving user profile: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error saving profile')),
          );
        }
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? Icon(Icons.add_a_photo, size: 50)
                  : null,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveUserProfile,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Text color
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
