import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class BeverageSection extends StatefulWidget {
  const BeverageSection({super.key});

  @override
  _BeverageSectionState createState() => _BeverageSectionState();
}

class _BeverageSectionState extends State<BeverageSection> {
  final Map<String, String> _shopNamesCache = {}; // ✅ Cache shop names

  /// ✅ Fetch shop name from Firestore using shopId
  Future<String> _fetchShopName(String shopId) async {
    if (_shopNamesCache.containsKey(shopId)) {
      return _shopNamesCache[shopId]!; // ✅ Return cached name
    }

    try {
      DocumentSnapshot shopDoc =
          await FirebaseFirestore.instance.collection('shops').doc(shopId).get();

      if (shopDoc.exists) {
        String shopName = shopDoc['name'] ?? "Unknown Shop";
        _shopNamesCache[shopId] = shopName; // ✅ Cache shop name
        return shopName;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }

    return "Unknown Shop";
  }

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

        final beverageProducts = provider.products
            .where((product) =>
                product['category']?.toString().toLowerCase() == 'beverage')
            .toList();

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

              final List<dynamic>? images = product['imageUrls'] as List<dynamic>?;
              final String imageUrl = (images != null && images.isNotEmpty && images.first is String)
                  ? images.first.toString()
                  : 'https://via.placeholder.com/150';

              final String shopId = product['shopId'] ?? 'unknown_shop';

              return FutureBuilder<String>(
                future: _fetchShopName(shopId), // ✅ Fetch shop name dynamically
                builder: (context, snapshot) {
                  String shopName = snapshot.data ?? "Loading...";

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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'RM${(product['price'] is num) ? product['price'].toStringAsFixed(2) : '0.00'}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        'Shop: $shopName', // ✅ Display shop name instead of shopId
                        style: const TextStyle(color: Colors.blue, fontSize: 12),
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
                              shopId: shopId,
                              shopName: shopName, // ✅ Store shop name
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
              );
            },
          ),
        );
      },
    );
  }
}
