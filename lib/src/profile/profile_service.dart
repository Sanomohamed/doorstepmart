import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Map<String, dynamic>> fetchUserData(String uid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData['profileImageUrl'] != null) {
        String profileImageUrl = userData['profileImageUrl'];
        File profileImageFile = await _downloadProfileImage(profileImageUrl);
        userData['profileImageFile'] = profileImageFile;
      }

      return userData;
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return {};
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

Future<String?> uploadProfileImage(File imageFile) async {
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
    rethrow;
  }
}

Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
  try {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await userRef.set(userData, SetOptions(merge: true));
  } catch (e) {
    print('Error saving user data: $e');
    rethrow;
  }
}