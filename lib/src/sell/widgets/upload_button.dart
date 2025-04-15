import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';//importing the necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    if (!formKey.currentState!.validate() || productData['category'] == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and select a category.");
      return;
    }

    onUploadStart();

    try {
      final user = FirebaseAuth.instance.currentUser;
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
      final shopName = shopSnapshot.docs.first.data()['shopName'] ?? 'Shop';
      List<String> imageUrls = List<String>.from(productData['existingImages']);

      // Loop through the image paths and upload each image
      for (var path in productData['imagePaths']) {
        final file = File(path);
        final fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        final task = FirebaseStorage.instance.ref(fileName).putFile(file);
        final snapshot = await task;
        final url = await snapshot.ref.getDownloadURL(); // Get the download URL of the uploaded image
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
        await FirebaseFirestore.instance.collection('products').doc(productId).update(data);
        Fluttertoast.showToast(msg: "Product updated successfully");
      } else {
        await FirebaseFirestore.instance.collection('products').add(data);
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
