import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      for (var path in productData['imagePaths']) {
        final file = File(path);
        final fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        final task = FirebaseStorage.instance.ref(fileName).putFile(file);
        final snapshot = await task;
        final url = await snapshot.ref.getDownloadURL();
        imageUrls.add(url);
      }

      final data = {
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
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _handleUpload(context),
        icon: const Icon(Icons.upload),
        label: Text(productId != null ? "Update Product" : "Upload Product"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      ),
    );
  }
}
