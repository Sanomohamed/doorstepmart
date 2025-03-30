import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductActions extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isUploading;
  final String? productId;
  final Map<String, dynamic> productData;
  final VoidCallback onUploadStart;
  final VoidCallback onUploadEnd;

  const ProductActions({
    super.key,
    required this.formKey,
    required this.isUploading,
    required this.productId,
    required this.productData,
    required this.onUploadStart,
    required this.onUploadEnd,
  });

  Future<void> _uploadProduct(BuildContext context) async {
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
      for (var imagePath in productData['imagePaths']) {
        File file = File(imagePath);
        String fileName = "products/${DateTime.now().millisecondsSinceEpoch}.jpg";
        UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

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

      // Close the form and refresh the grid
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      onUploadEnd();
    }
  }

  Future<void> _deleteProduct(BuildContext context) async {
    if (productId != null) {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      Fluttertoast.showToast(msg: "Product deleted successfully");
      if (context.mounted) {
        Navigator.pop(context, true); // Refresh the product grid
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () => _uploadProduct(context),
                icon: const Icon(Icons.upload),
                label: Text(productId != null ? "Update Product" : "Upload Product"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              if (productId != null) ...[
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => _deleteProduct(context),
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete Product"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ]
            ],
          );
  }
}
