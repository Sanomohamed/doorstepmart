import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shop_page/shop_product_card.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  final String shopId;
  const ShopPage({super.key, required this.shopId});

  // Fetch the shop name from Firestore
  Future<String> _fetchShopName() async {
    final doc = await FirebaseFirestore.instance
        .collection('shops')
        .doc(shopId)
        .get();
    return doc.data()?['shopName'] ?? 'Shop';
  }

  // Fetch the products once
  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    final snap = await FirebaseFirestore.instance
        .collection('products')
        .where('shopId', isEqualTo: shopId)
        .get();
    return snap.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Base column count based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final baseColumns = screenWidth > 1000
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _fetchShopName(),
          builder: (ctx, snap) => Text(snap.data ?? 'Shop'),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                "Error loading products:\n${snap.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final products = snap.data!;
          if (products.isEmpty) {
            return const Center(
              child: Text("No products found for this shop."),
            );
          }

          // If fewer products than baseColumns, shrink columns
          final columnCount = products.length < baseColumns
              ? products.length
              : baseColumns;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: GridView.builder(
                  padding: EdgeInsets.zero,        // no outer padding
                  itemCount: products.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,   // dynamic count
                    crossAxisSpacing: 8,           // tight spacing
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (ctx, i) {
                    return ShopProductCard(
                      product: products[i],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
