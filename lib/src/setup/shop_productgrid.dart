import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/sell/sell.dart';
import 'package:doorstepmart/src/sell/sell_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopProductGrid extends StatefulWidget {
  const ShopProductGrid({super.key});

  @override
  State<ShopProductGrid> createState() => ShopProductGridState();
}

class ShopProductGridState extends State<ShopProductGrid> {
  late String _userId;
  bool _isLoading = true;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchShopProducts();
  }
   Future<void> refresh() async {
    await _fetchShopProducts(); // ✅ Call your fetch function
  }

  Future<void> _fetchShopProducts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    _userId = user.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: _userId)
        .get();

    setState(() {
      _products = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(String productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
    _fetchShopProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(child: Text('No products found for this shop.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final product = _products[index];
        final imageUrl = (product['imageUrls'] as List<dynamic>?)?.first ?? 'https://via.placeholder.com/150';
        final name = product['name'] ?? 'Unnamed';
        final price = product['price'] ?? 0.0;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('RM${price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellForm(
                                  productData: product,
                                  productId: product['id'],
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product['id']),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
