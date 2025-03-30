import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shop_page.dart';

class ShopInfo extends StatelessWidget {
  final String shopId;

  const ShopInfo({super.key, required this.shopId});

  Future<String> _fetchShopName(String shopId) async {
    try {
      final shopDoc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
      if (shopDoc.exists) {
        return shopDoc.data()?['shopName'] ?? "Unknown Shop";
      }
    } catch (e) {
      debugPrint("Error fetching shop name: $e");
    }
    return "Unknown Shop";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchShopName(shopId),
      builder: (context, snapshot) {
        final shopName = snapshot.data ?? 'Loading...';

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ShopPage(shopId: shopId)));
          },
          child: Text(
            shopName,
            style: const TextStyle(fontSize: 16, color: Colors.blueAccent, decoration: TextDecoration.underline),
          ),
        );
      },
    );
  }
}
