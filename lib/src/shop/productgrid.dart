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

    // ✅ Handle loading, errors, and empty state
    if (productProvider.isLoading) return const Center(child: CircularProgressIndicator());
    if (productProvider.hasError) return const Center(child: Text('Error fetching products'));
    if (productProvider.products.isEmpty) return const Center(child: Text('No products available'));

    // ✅ Responsive grid column count
    int columnCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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

          // ✅ Fetch product details safely
          final String imageUrl = (product['imageUrls'] as List<dynamic>?)?.firstOrNull ?? 'https://via.placeholder.com/150';
          final String name = product['name']?.toString() ?? 'Unknown Product';
          final double price = (product['price'] as num?)?.toDouble() ?? 0.0;

          final bool isFavorite = favoriteModel.favorites.any((item) => item.name == name);

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.network(
                        'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM${price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(214, 118, 190, 121)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Add to Favorites Button with animation
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: const Color.fromARGB(206, 219, 70, 60),
                          size: 30,
                        ),
                        onPressed: () {
                          if (!isFavorite) {
                            favoriteModel.add(FavoriteItem(name: name, image: imageUrl, price: price));
                            _showSnackbar(context, '$name added to favorites');
                          } else {
                            _showSnackbar(context, '$name is already in favorites');
                          }
                        },
                      ),

                      // ✅ Add to Cart Button with animation
                      ElevatedButton(
                        onPressed: () {
                          cartModel.add(CartItem(name: name, image: imageUrl, price: price, quantity: 1));
                          _showSnackbar(context, '$name added to cart');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: const Color.fromARGB(193, 76, 175, 79),
                        ),
                        child: const Icon(Icons.add, 
                        color: Colors.white,
                        size: 30,),
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

  // ✅ Helper function for Snackbars
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 800)),
    );
  }
}
