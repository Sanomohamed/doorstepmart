import 'package:doorstepmart/services/product.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class BeverageSection extends StatelessWidget {
  const BeverageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.hasError) {
          return const Center(child: Text('Error fetching products'));
        }
        if (provider.products.isEmpty) {
          return const Center(child: Text('No beverages available'));
        }

        // ✅ Ensure category name is lowercase
        final beverageProducts = provider.products
            .where((product) =>
                product['category']?.toString().toLowerCase() == 'beverage')
            .toList();

        // ✅ Prevent empty beverage list from breaking UI
        if (beverageProducts.isEmpty) {
          return const Center(child: Text('No beverages available'));
        }

        return SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: beverageProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              final product = beverageProducts[index];

              // ✅ Fetch product image correctly from imageUrls
              final List<dynamic>? images = product['imageUrls'] as List<dynamic>?;
              final String imageUrl = (images != null && images.isNotEmpty && images.first is String)
                  ? images.first.toString()
                  : 'https://via.placeholder.com/150';

              return Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    height: 160,
                    width: 150,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product['name'] ?? 'Unnamed Product',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'RM${product['price'] ?? '0.00'}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      Provider.of<CartModel>(context, listen: false).add(
                        CartItem(
                          name: product['name'] ?? '',
                          image: imageUrl,
                          price: (product['price'] is num)
                              ? product['price'].toDouble()
                              : 0.0,
                          quantity: 1,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} added to cart'),
                          duration: const Duration(milliseconds: 700),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
} 