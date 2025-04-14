import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/orderlist.dart';  // Importing necessary packages and files
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopOrderManagementPage extends StatelessWidget {
  const ShopOrderManagementPage({super.key});

  Future<String?> getShopId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('shops')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }
// The build method creates the UI for the Shop Order Management page.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getShopId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final shopId = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shop Order Management'),
            backgroundColor: Colors.green,
          ),
// OrderList widget to display the list of orders for the shop.
          body: OrderList(shopId: shopId),
        );
      },
    );
  }
}
