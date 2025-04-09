import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//importing the necessary packages and files

class ProductActions {
  /// Uploads product data to Firestore and Firebase Storage.
  static Future<void> upload({
    //static method to upload product data
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required bool isUploading,
    required String? productId,
    required Map<String, dynamic> productData,
    required VoidCallback onUploadStart,
    required VoidCallback onUploadEnd,
  }) async {
    // Check if the form is valid and a category is selected
    // If not, show a toast message and return
    if (!formKey.currentState!.validate() || productData['category'] == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and select a category.");
      return;
    }

    onUploadStart();
    // Start the upload process
    // This method handles the upload of product data to Firestore and Firebase Storage.

    try {
      final user = FirebaseAuth.instance.currentUser;
      // Check if the user is logged in
      // If not, show a toast message and return
      if (user == null) throw Exception("User not logged in");

      final shopSnapshot = await FirebaseFirestore.instance
          //fetching the shop details from Firestore
          // This query fetches the shop details for the logged-in user
          .collection("shops")
          .where("userId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnapshot.docs.isEmpty) {
        // If no shop is found, show a toast message and return
        // This message indicates that the user needs to create a shop before uploading products
        Fluttertoast.showToast(msg: "You need to create a shop first.");
        return;
      }

      final shopId = shopSnapshot.docs.first.id;
      // Get the shop name from the snapshot
      // If the shop name is not found, use a default value
      final shopName = shopSnapshot.docs.first.data()['shopName'] ?? 'Shop';

      List<String> imageUrls = List<String>.from(productData['existingImages']);
      // This list will hold the URLs of the uploaded images
      // Upload new images to Firebase Storage and get their URLs
      for (var imagePath in productData['imagePaths']) {
        // This loop iterates through the image paths and uploads each image to Firebase Storage
        // The image path is expected to be a local file path
        File file = File(imagePath);
        String fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      final updatedProductData = {
        // This map contains the product data to be uploaded to Firestore
        'name': productData['name'],
        'price': double.parse(productData['price']),
        'description': productData['description'],
        'category': productData['category'],
        'imageUrls': imageUrls,
        'shopId': shopId,
        'shopName': shopName,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (productId != null) {
        // If productId is not null, update the existing product in Firestore
        await FirebaseFirestore.instance.collection('products').doc(productId).update(updatedProductData);
        Fluttertoast.showToast(msg: "Product updated successfully");
      } else {
        await FirebaseFirestore.instance.collection('products').add(updatedProductData);
        Fluttertoast.showToast(msg: "Product uploaded successfully");
      }

      if (context.mounted) Navigator.pop(context, true); // refresh grid
    } catch (e) {
      Fluttertoast.showToast(msg: "Upload failed: $e");
    } finally {
      onUploadEnd();
    }
  }
}
