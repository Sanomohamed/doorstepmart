import 'package:doorstepmart/src/shop/shop_page/shop_product_card.dart';//importing the necessary packages and files 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPage extends StatelessWidget {
  final String shopId;   const ShopPage({super.key, required this.shopId});
//fetching the shop name from Firestore using the shopId
  Future<String> _fetchShopName() async {
    final doc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
    return doc.data()?['shopName'] ?? 'Shop';
  }

  @override
  Widget build(BuildContext context) {
    //using MediaQuery to get the screen width and determine the number of columns for the grid
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = screenWidth > 1000 ? 4 : screenWidth > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _fetchShopName(),
          builder: (context, snapshot) => Text(snapshot.data ?? 'Shop'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('shopId', isEqualTo: shopId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
               return const Center(child: CircularProgressIndicator());

          } if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found for this shop."));
          }

          final products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return ShopProductCard(product: products[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
