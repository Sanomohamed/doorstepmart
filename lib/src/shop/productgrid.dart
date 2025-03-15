import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      if (productProvider.products.isEmpty) {
        productProvider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.hasError) {
      return const Center(child: Text('Error fetching products'));
    }
    if (productProvider.products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: productProvider.products.length,
        itemBuilder: (context, index) {
          final product = productProvider.products[index];

          // ✅ Fetch product image correctly from imageUrls
          final List<dynamic>? images = product['imageUrls'] as List<dynamic>?;
          String imageUrl = images != null && images.isNotEmpty && images.first is String
              ? images.first.toString()
              : '';

          // ✅ Check if image URL is valid
          bool isValidImageUrl = imageUrl.startsWith('https://firebasestorage.googleapis.com/');
          if (!isValidImageUrl) {
            imageUrl = 'https://via.placeholder.com/150'; // Default placeholder
          }

          // ✅ Fetch product details safely
          final String name = product['name']?.toString() ?? 'Unknown Product';
          final double price = (product['price'] is num)
              ? (product['price'] as num).toDouble()
              : 0.0;

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        print('❌ Error loading image: $url, error: $error');
                        return Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Add to Favorites Button
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: () {
                          final favoriteModel = Provider.of<FavoriteModel>(context, listen: false);
                          final isAlreadyFavorite = favoriteModel.favorites.any((item) => item.name == name);
                          if (!isAlreadyFavorite) {
                            favoriteModel.add(
                              FavoriteItem(
                                name: name,
                                image: imageUrl,
                                price: price,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$name added to favorites'),
                                duration: const Duration(milliseconds: 700),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$name is already in favorites'),
                                duration: const Duration(milliseconds: 700),
                              ),
                            );
                          }
                        },
                      ),

                      // ✅ Add to Cart Button
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<CartModel>(context, listen: false).add(
                            CartItem(
                              name: name,
                              image: imageUrl,
                              price: price,
                              quantity: 1,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name added to cart'),
                              duration: const Duration(milliseconds: 700),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.green,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
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
}
