import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
//importing the necessary packages and files

class UploadButton extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final String? productId;
  final Map<String, dynamic> productData;
  final VoidCallback onUploadStart;
  final VoidCallback onUploadEnd;

  const UploadButton({
    super.key,
    required this.formKey,
    required this.productId,
    required this.productData,
    required this.onUploadStart,
    required this.onUploadEnd,
  });

  Future<void> _handleUpload(BuildContext context) async {
    // Check if the form is valid and a category is selected
    // If not, show a toast message and return
    if (!formKey.currentState!.validate() || productData['category'] == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and select a category.");
      return;
    }

    onUploadStart();

    try {
      final user = FirebaseAuth.instance.currentUser;
      // Check if the user is logged in
      // If not, show a toast message and return
      if (user == null) throw Exception("User not logged in");

      final shopSnapshot = await FirebaseFirestore.instance
      //fetching the shop details from Firestore
          .collection("shops")
          .where("userId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnapshot.docs.isEmpty) {
        // If no shop is found, show a toast message and return
        Fluttertoast.showToast(msg: "You need to create a shop first.");
        return;
      }

      final shopId = shopSnapshot.docs.first.id;
      // Get the shop name from the snapshot
      // If the shop name is not found, use a default value
      final shopName = shopSnapshot.docs.first.data()['shopName'] ?? 'Shop';

      List<String> imageUrls = List<String>.from(productData['existingImages']);
      // Upload new images to Firebase Storage and get their URLs
      // Loop through the image paths and upload each image
      for (var path in productData['imagePaths']) {
        final file = File(path);
        final fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        final task = FirebaseStorage.instance.ref(fileName).putFile(file);
        final snapshot = await task;
        // Get the download URL of the uploaded image
        // This URL will be used to display the image in the app
        final url = await snapshot.ref.getDownloadURL();
        imageUrls.add(url);
      }

      final data = {
        // Create a map with the product data to be uploaded to Firestore
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
        // Otherwise, add a new product to Firestore
        await FirebaseFirestore.instance.collection('products').doc(productId).update(data);
        Fluttertoast.showToast(msg: "Product updated successfully");
      } else {
        await FirebaseFirestore.instance.collection('products').add(data);
        // Add a new product to Firestore
        // Show a toast message indicating that the product was uploaded successfully
        Fluttertoast.showToast(msg: "Product uploaded successfully");
      }

      if (context.mounted) Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      onUploadEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the upload button with an icon and label
    // The button will call the _handleUpload method when pressed
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _handleUpload(context),
        icon: const Icon(Icons.upload),
        label: Text(productId != null ? "Update Product" : "Upload Product",style: TextStyle(color: Colors.black),),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      ),
    );
  }
}
