import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/sell/sell_form.dart';
import 'package:doorstepmart/src/setup/widget/confirm_snackbar.dart';
import 'package:doorstepmart/src/setup/widget/shoproduct_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//importing necessary packages and files for the ShopProductGrid widget

class ShopProductGrid extends StatefulWidget {
  const ShopProductGrid({super.key});

  @override
  State<ShopProductGrid> createState() => ShopProductGridState();
}

class ShopProductGridState extends State<ShopProductGrid> {
  /// State for the ShopProductGrid widget
  /// This state manages the loading state and the list of products.
  bool _isLoading = true;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchShopProducts();
  }

  Future<void> refresh() async => _fetchShopProducts();
  /// Refreshes the product list by calling the _fetchShopProducts method.
  /// This method is called when the user pulls down to refresh the product list.

  Future<void> _fetchShopProducts() async {
    /// Fetches the products for the current user from Firestore.
    /// This method retrieves the products from the Firestore database and updates the state.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    final snapshot = await FirebaseFirestore.instance
    //fetching the products from the Firestore database

        .collection('products')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      /// Updates the state with the fetched products and sets loading to false.
      /// The products are stored in a list of maps, where each map contains the product data.
      _products = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      _isLoading = false;
    });
  }

  Future<void> _confirmDelete(String productId) async {
    /// Shows a confirmation dialog to delete a product.
    /// If the user confirms, deletes the product from Firestore and refreshes the product list.
    await showDeleteConfirmationBottomSheet(
      context: context,
      onConfirmed: () async {
        /// Deletes the product from Firestore and refreshes the product list.
        /// This method is called when the user confirms the deletion.
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
      /// Center the product grid in the available space
      /// This widget is used to center the product grid in the available space.
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            /// Refresh indicator for the product grid
            /// This widget is used to show a loading spinner when the user pulls down to refresh the product list.
            onRefresh: refresh,
            child: _isLoading || _products.isEmpty
                ? _buildLoaderOrEmpty()
                /// If the product list is empty or loading, show a loader or empty message.
                /// Otherwise, show the product grid.
                : _buildGrid(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoaderOrEmpty() {
    /// Shows a loading spinner or an empty message based on the loading state.
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    /// If the product list is empty, show a message indicating that there are no products.
    return const Center(child: Text('No products found for this shop.'));
  }

  Widget _buildGrid(BuildContext context) {
    /// Builds the product grid using a GridView.builder.
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
            /// Navigates to the SellForm page with the selected product data.
            /// This method is called when the user taps on the edit button of a product.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SellForm(
                  /// Pass the product data to the SellForm page
                  /// This allows the user to edit the product details.
                  productData: product,
                  productId: product['id'],
                ),
              ),
            );
          },
          onDelete: () => _confirmDelete(product['id']),
          /// Shows a confirmation dialog to delete the product.
          /// If the user confirms, deletes the product from Firestore and refreshes the product list.
        );
      },
    );
  }
}
