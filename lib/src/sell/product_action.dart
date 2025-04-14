import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';  //importing the necessary packages and files
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductActions {
// Uploads product data to Firestore and Firebase Storage.
    static Future<void> upload({

    required BuildContext context,

    required GlobalKey<FormState> formKey,

    required bool isUploading,
    required String? productId,
    required Map<String, dynamic> productData,
    required VoidCallback onUploadStart,
    required VoidCallback onUploadEnd,
  }) async {
  
    if (!formKey.currentState!.validate() || productData['category'] == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and select a category.");
      return;
    }

    onUploadStart();

    try {
      final user = FirebaseAuth.instance.currentUser;
     
      if (user == null) throw Exception("User not logged in");

      final shopSnapshot = await FirebaseFirestore.instance
          .collection("shops")
          .where("userId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnapshot.docs.isEmpty) {
        
        Fluttertoast.showToast(msg: "You need to create a shop first.");
        return;
      }

      final shopId = shopSnapshot.docs.first.id;
     
      final shopName = shopSnapshot.docs.first.data()['shopName'] ?? 'Shop';

      List<String> imageUrls = List<String>.from(productData['existingImages']);
// This loop iterates through the image paths and uploads each image to Firebase Storage    
      for (var imagePath in productData['imagePaths']) {
        File file = File(imagePath);
        String fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
// This map contains the product data to be uploaded to Firestore
      final updatedProductData = {
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
