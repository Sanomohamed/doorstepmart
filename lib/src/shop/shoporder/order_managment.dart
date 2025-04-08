import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/orderlist.dart';  
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
          body: OrderList(shopId: shopId),
        );
      },
    );
  }
}
