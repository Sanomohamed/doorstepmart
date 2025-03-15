import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<Map<String, dynamic>> fetchUserData(String uid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Ensure the profile image URL is valid
      if (userData['profileImageUrl'] == null || userData['profileImageUrl'].toString().isEmpty) {
        userData['profileImageUrl'] = null; // Avoid setting an invalid placeholder
      }

      return userData;
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return {};
}

Future<String?> uploadProfileImage(File imageFile) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } else {
      throw Exception('User not logged in');
    }
  } catch (e) {
    print('Error uploading profile image: $e');
    return null;
  }
}

Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
  try {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await userRef.set(userData, SetOptions(merge: true));
  } catch (e) {
    print('Error saving user data: $e');
  }
}
