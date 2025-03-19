import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final favoriteModel = Provider.of<FavoriteModel>(context);
    final cartModel = Provider.of<CartModel>(context);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.hasError) {
      return const Center(child: Text('Error fetching products'));
    }
    if (productProvider.products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    int columnCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          childAspectRatio: 0.75,
        ),
        itemCount: productProvider.products.length,
        itemBuilder: (context, index) {
          final product = productProvider.products[index];

          final String imageUrl = (product['imageUrls'] as List<dynamic>?)?.firstOrNull ??
              'https://via.placeholder.com/150';
          final String name = product['name']?.toString() ?? 'Unknown Product';
          final double price = (product['price'] as num?)?.toDouble() ?? 0.0;
          final String shopId = product['shopId']?.toString() ?? 'Unknown Shop';

          final bool isFavorite = favoriteModel.isFavorite(name);
          final CartItem? existingCartItem = cartModel.items
              .where((item) => item.name == name && item.shopId == shopId)
              .isNotEmpty
              ? cartModel.items.firstWhere((item) => item.name == name && item.shopId == shopId)
              : null;

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ Image Section
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Image.network('https://via.placeholder.com/150', fit: BoxFit.cover),
                    ),
                  ),
                ),

                // ✅ Product Details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'RM${price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        'Shop ID: $shopId',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // ✅ Buttons Section (Favorite & Add to Cart)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Favorite Button
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 26,
                        ),
                        onPressed: () {
                          if (!isFavorite) {
                            favoriteModel.add(
                              FavoriteItem(name: name, image: imageUrl, price: price, shopId: shopId),
                            );
                            _showSnackbar(context, '$name added to favorites');
                          } else {
                            favoriteModel.remove(name);
                            _showSnackbar(context, '$name removed from favorites');
                          }
                        },
                      ),

                      // ✅ Add to Cart Button (Now allows multiple additions)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (existingCartItem == null) {
                              cartModel.add(
                                CartItem(
                                  name: name,
                                  image: imageUrl,
                                  price: price,
                                  shopId: shopId,
                                  quantity: 1,
                                ),
                              );
                              _showSnackbar(context, '$name added to cart');
                            } else {
                              cartModel.increaseQuantity(existingCartItem);
                              _showSnackbar(context, 'Increased quantity for $name');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          child: existingCartItem != null
                              ? Text(
                                  'Qty: ${existingCartItem.quantity}',
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                )
                              : const Text(
                                  'Add to Cart',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 800)),
    );
  }
}
