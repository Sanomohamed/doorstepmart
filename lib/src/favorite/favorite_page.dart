import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final Map<String, String> _shopNamesCache = {};

  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteModel>(context, listen: false).loadFavorites();
  }

  // Fetch shop name from Firestore
  Future<String> _fetchShopName(String shopId) async {
    if (_shopNamesCache.containsKey(shopId)) return _shopNamesCache[shopId]!;

    try {
      DocumentSnapshot shopDoc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
      if (shopDoc.exists) {
        String shopName = shopDoc['name'] ?? "Unknown Shop";
        _shopNamesCache[shopId] = shopName;
        return shopName;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }
    return "Unknown Shop";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFEFFAF1),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
          if (favoriteModel.favorites.isEmpty) {
            return const Center(
              child: Text("No favorite items found!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
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

                return Stack(
                  children: [
                    _buildFavoriteCard(product),
                    _buildDeleteButton(context, product),
                    _buildAddToCartButton(context, product),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// ✅ Favorite Product Card
  Widget _buildFavoriteCard(FavoriteItem product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, spreadRadius: 2)],
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
                Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('RM${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                Text(product.shopName, style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Delete Button
  Widget _buildDeleteButton(BuildContext context, FavoriteItem product) {
    return Positioned(
      bottom: 15,
      left: 15,
      child: _buildIconButton(Icons.delete, Colors.red, () {
        Provider.of<FavoriteModel>(context, listen: false).remove(product.name);
      }),
    );
  }

  /// ✅ Add to Cart Button
  Widget _buildAddToCartButton(BuildContext context, FavoriteItem product) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: _buildIconButton(Icons.add_shopping_cart, Colors.green, () {
        Provider.of<CartModel>(context, listen: false).add(CartItem(
          name: product.name, image: product.image, price: product.price, quantity: 1, shopId: product.shopId, shopName: product.shopName));
      }),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(backgroundColor: color, radius: 22, child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed));
  }
}
