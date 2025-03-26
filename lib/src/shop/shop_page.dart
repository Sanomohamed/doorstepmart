import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/product/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';

class ShopPage extends StatelessWidget {
  final String shopId;

  const ShopPage({super.key, required this.shopId});

  Future<String> _fetchShopName() async {
    final doc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
    if (doc.exists) {
      return doc.data()?['shopName'] ?? 'Shop';
    }
    return 'Shop';
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final favoriteModel = Provider.of<FavoriteModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _fetchShopName(),
          builder: (context, snapshot) {
            return Text(snapshot.data ?? 'Shop');
          },
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
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found for this shop."));
          }

          final products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          int columnCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final String imageUrl = (product['imageUrls'] as List<dynamic>?)?.firstOrNull ?? 'https://via.placeholder.com/150';
              final String name = product['name'] ?? 'Product';
              final double price = (product['price'] as num?)?.toDouble() ?? 0.0;
              final String shopName = product['shopName'] ?? 'Shop';
              final String shopId = product['shopId'] ?? '';

              final bool isFavorite = favoriteModel.isFavorite(name);
              final CartItem? existingCartItem = cartModel.items
                  .where((item) => item.name == name && item.shopId == shopId)
                  .isNotEmpty
                  ? cartModel.items.firstWhere((item) => item.name == name && item.shopId == shopId)
                  : null;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.network('https://via.placeholder.com/150'),
                          ),
                        ),
                      ),

                      // Product Info
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'RM${price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ),

                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Favorite
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  favoriteModel.remove(name);
                                  _showSnackbar(context, '$name removed from favorites');
                                } else {
                                  favoriteModel.add(FavoriteItem(
                                    name: name,
                                    image: imageUrl,
                                    price: price,
                                    shopId: shopId,
                                    shopName: shopName,
                                  ));
                                  _showSnackbar(context, '$name added to favorites');
                                }
                              },
                            ),

                            // Add to Cart
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (existingCartItem == null) {
                                    cartModel.add(CartItem(
                                      name: name,
                                      image: imageUrl,
                                      price: price,
                                      shopId: shopId,
                                      shopName: shopName,
                                      quantity: 1,
                                    ));
                                    _showSnackbar(context, '$name added to cart');
                                  } else {
                                    cartModel.increaseQuantity(existingCartItem);
                                    _showSnackbar(context, 'Increased quantity for $name');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text(
                                  existingCartItem != null
                                      ? 'Qty: ${existingCartItem.quantity}'
                                      : 'Add to Cart',
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 900)),
    );
  }
}
