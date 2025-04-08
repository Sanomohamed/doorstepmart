import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/sell/sell_form.dart';
import 'package:doorstepmart/src/setup/widget/confirm_snackbar.dart';
import 'package:doorstepmart/src/setup/widget/shoproduct_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopProductGrid extends StatefulWidget {
  const ShopProductGrid({super.key});

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

  Future<void> refresh() async => _fetchShopProducts();

  Future<void> _fetchShopProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      _products = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      _isLoading = false;
    });
  }

  Future<void> _confirmDelete(String productId) async {
    await showDeleteConfirmationBottomSheet(
      context: context,
      onConfirmed: () async {
        await FirebaseFirestore.instance.collection('products').doc(productId).delete();
        _fetchShopProducts();

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: refresh,
            child: _isLoading || _products.isEmpty
                ? _buildLoaderOrEmpty()
                : _buildGrid(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoaderOrEmpty() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return const Center(child: Text('No products found for this shop.'));
  }

  Widget _buildGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = screenWidth > 1000 ? 4 : screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = _products[index];
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
    );
  }
}
