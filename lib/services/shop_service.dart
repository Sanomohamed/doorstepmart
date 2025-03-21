import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class ShopServices {
  /// ✅ Create a new shop
  static Future<void> createShop(
    BuildContext context, // 🔹 Pass context here
    String shopName,
    String state,
    String city,
    File? image,
    List<String> days,
    TimeOfDay? opening,
    TimeOfDay? closing,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    // ✅ Check if the user already has a shop
    QuerySnapshot shopSnapshot = await FirebaseFirestore.instance
        .collection("shops")
        .where("userId", isEqualTo: user.uid)
        .get();

    if (shopSnapshot.docs.isNotEmpty) {
      throw Exception("You already have a shop.");
    }

    // ✅ Generate a unique shop ID
    String shopId = const Uuid().v4();
    String imageUrl = image != null ? await _uploadImage(shopId, image) : "";

    // ✅ Prepare shop data
    Map<String, dynamic> shopData = {
      "shopId": shopId,
      "userId": user.uid,
      "shopName": shopName.trim(),
      "location": {
        "state": state,
        "city": city,
      },
      "operatingDays": days,
      "operatingHours": {
        "opening": opening != null ? opening.format(context) : "Not set",
        "closing": closing != null ? closing.format(context) : "Not set",
      },
      "shopImageUrl": imageUrl,
      "createdAt": Timestamp.now(),
    };

    // ✅ Save shop data to Firestore
    await FirebaseFirestore.instance.collection("shops").doc(shopId).set(shopData);
  }

  /// ✅ Upload shop profile image to Firebase Storage
  static Future<String> _uploadImage(String shopId, File image) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('shops/$shopId/profile.jpg')
        .putFile(image);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// ✅ Fetch shop name by shopId
  static Future<String> fetchShopName(String shopId) async {
    try {
      DocumentSnapshot shopDoc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();

      if (shopDoc.exists && shopDoc.data() != null) {
        Map<String, dynamic> shopData = shopDoc.data() as Map<String, dynamic>;
        return shopData['shopName'] ?? "Unknown Shop";
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }

    return "Unknown Shop";
  }
}
