import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/setup/widget/shoproduct_card.dart';
import 'package:doorstepmart/src/sell/sell_form.dart';
import 'package:doorstepmart/src/setup/widget/confirm_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopProductGrid extends StatefulWidget {
  /// Optional search query for filtering products by name
  final String searchQuery;
  const ShopProductGrid({Key? key, this.searchQuery = ''}) : super(key: key);

  @override
  State<ShopProductGrid> createState() => ShopProductGridState();
}

class ShopProductGridState extends State<ShopProductGrid> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchShopProducts();
  }

  /// Called by parent RefreshIndicator to reload products
  Future<void> refresh() async {
    await _fetchShopProducts();
  }

  Future<void> _fetchShopProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      _products = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _confirmDelete(String productId) async {
    await showDeleteConfirmationBottomSheet(
      context: context,
      onConfirmed: () async {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .delete();
        await _fetchShopProducts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product deleted successfully")),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Apply search filtering if a query is provided
    final filteredProducts = widget.searchQuery.isEmpty
        ? _products
        : _products.where((p) {
            final name = (p['name'] ?? '').toString().toLowerCase();
            return name.contains(widget.searchQuery.toLowerCase());
          }).toList();

    if (filteredProducts.isEmpty) {
      return const Center(child: Text('No products match your search.'));
    }

    // Determine number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = screenWidth > 1000
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: filteredProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ShopProductCard(
            product: product,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SellForm(
                    productData: product,
                    productId: product['id'],
                  ),
                ),
              );
            },
            onDelete: () => _confirmDelete(product['id']),
          );
        },
      ),
    );
  }
}
