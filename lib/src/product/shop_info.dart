import 'package:doorstepmart/src/shop/shop_page/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        return Row(
          children: [
            const Text(
              "Visit Shop: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShopPage(shopId: shopId)),
                );
              },
              child: Text(
                shopName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.none, // ✅ No underline
                ),
              ),
              
            ),
          ],
        );
      },
    );
  }
}
