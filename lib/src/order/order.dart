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

    // ✅ Group items by shopId
    Map<String, List<CartItem>> shopOrders = {};
    for (var item in cartItems) {
      shopOrders.putIfAbsent(item.shopId, () => []).add(item);
    }

    // ✅ Loop through each shop and create an order
    for (var entry in shopOrders.entries) {
      String shopId = entry.key;
      List<CartItem> items = entry.value;

      // ✅ Fetch shop name from Firestore
      String shopName = 'Unknown Shop';
      final shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
      if (shopSnapshot.exists) {
        final shopData = shopSnapshot.data();
        shopName = shopData?['shopName'] ?? shopName;
      }

      // ✅ Format order items
      final orderItems = items.map((item) => {
        "name": item.name,
        "price": item.price,
        "quantity": item.quantity,
        "image": item.image,
      }).toList();

      // ✅ Calculate total for this shop
      double shopTotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

      // ✅ Create order data
      final orderData = {
        "userId": user.uid,
        "userName": userName,
        "shopId": shopId,
        "shopName": shopName,
        "orderItems": orderItems,
        "totalAmount": shopTotal,
        "paymentMethod": paymentMethod,
        "status": "Pending",
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
    }

    // ✅ Show success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Orders placed successfully")),
    );
  } catch (e) {
    print("❌ Order error: $e");
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Failed to place order")),
    );
  }
}
