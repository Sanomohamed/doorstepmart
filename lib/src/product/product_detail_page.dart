import 'package:doorstepmart/src/shop/productgrid.dart';
import 'package:doorstepmart/src/shop/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/checkout/checkout_page.dart'; // ← Create this page

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  Future<String> _fetchShopName(String shopId) async {
    try {
      final shopDoc =
          await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
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
    final cartModel = Provider.of<CartModel>(context);

    final String imageUrl = (product['imageUrls'] as List<dynamic>?)?.firstOrNull ??
        'https://via.placeholder.com/150';
    final String name = product['name'] ?? 'Unnamed Product';
    final double price = (product['price'] as num?)?.toDouble() ?? 0.0;
    final String description = product['description'] ?? '';
    final String shopId = product['shopId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<String>(
        future: _fetchShopName(shopId),
        builder: (context, snapshot) {
          final shopName = snapshot.data ?? 'Loading...';

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 420,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Name & Price
                    Text(name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('RM${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600)),

                    const SizedBox(height: 12),

                    // ✅ Shop Name (clickable)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShopPage(shopId: shopId),
                          ),
                        );
                      },
                      child: Text(
                        shopName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Description
                    const Text("Product Description",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(description.isNotEmpty ? description : "No description available.",
                        style: const TextStyle(fontSize: 16)),

                    const SizedBox(height: 30),

                    // ✅ Related Products Grid (reuse existing)
                    const Text("More Products",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const ProductGrid(),
                  ],
                ),
              ),

              // ✅ Bottom Button Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      // 🛒 Add to Cart Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cartModel.add(
                              CartItem(
                                name: name,
                                image: imageUrl,
                                price: price,
                                shopId: shopId,
                                shopName: shopName,
                                quantity: 1,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$name added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("Add to Cart"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
