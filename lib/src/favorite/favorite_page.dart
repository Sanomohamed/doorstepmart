import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(255, 237, 252, 237),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
          if (favoriteModel.favorites.isEmpty) {
            return const Center(
              child: Text(
                "No favorite items found!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: favoriteModel.favorites.length,
              itemBuilder: (context, index) {
                final product = favoriteModel.favorites[index];

                // ✅ Ensure `shopId` is present
                final String shopId = product.shopId ?? 'unknown_shop';

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'RM${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ DELETE BUTTON
                    Positioned(
                      bottom: 15,
                      left: 15,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 22,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white, size: 22),
                          onPressed: () {
                            Provider.of<FavoriteModel>(context, listen: false).remove(product.name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} removed from favorites'),
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ✅ ADD TO CART BUTTON (WITH SHOP ID)
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 22,
                        child: IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 22, color: Colors.white),
                          onPressed: () {
                            Provider.of<CartModel>(context, listen: false).add(
                              CartItem(
                                name: product.name,
                                image: product.image,
                                price: product.price,
                                quantity: 1,
                                shopId: shopId, // ✅ Include `shopId`
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
