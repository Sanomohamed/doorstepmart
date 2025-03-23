import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> placeOrder({
  required BuildContext context,
  required List<CartItem> cartItems,
  required double total,
  required String paymentMethod,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    // ✅ Get user data
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final userData = userSnapshot.data() ?? {};
    final userName = userData['displayName'] ?? 'Unknown User';

    // ✅ Get shopId from first item (assuming one shop per order)
    final shopId = cartItems.first.shopId;

    // ✅ Fetch shop name from Firestore
    String shopName = 'Unknown Shop';
    final shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
    if (shopSnapshot.exists) {
      final shopData = shopSnapshot.data();
      shopName = shopData?['shopName'] ?? shopName;
    }

    // ✅ Format order items
    final orderItems = cartItems.map((item) => {
      "name": item.name,
      "price": item.price,
      "quantity": item.quantity,
      "image": item.image,
    }).toList();

    final orderData = {
      "userId": user.uid,
      "userName": userName,
      "shopId": shopId,
      "shopName": shopName,
      "orderItems": orderItems,
      "totalAmount": total,
      "paymentMethod": paymentMethod,
      "status": "Pending", // ✅ New order status
      "timestamp": FieldValue.serverTimestamp(),
    };

    // ✅ Save order globally
    final orderRef = await FirebaseFirestore.instance.collection('orders').add(orderData);

    // ✅ Save order under user's personal order history
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderRef.id)
        .set(orderData);

    // ✅ Feedback
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Order placed successfully")),
    );
  } catch (e) {
    print("❌ Order error: $e");
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Failed to place order")),
    );
  }
}
