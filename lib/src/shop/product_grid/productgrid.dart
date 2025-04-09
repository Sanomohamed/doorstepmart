import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/shop/product_grid/productcart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//importing the necessary packages and files

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    /// Build method to create the UI for the ProductGrid
    final productProvider = Provider.of<ProductProvider>(context);
    /// Using Provider to access the ProductProvider instance
    final screenWidth = MediaQuery.of(context).size.width;
    /// Getting the screen width to determine the number of columns in the grid

    if (productProvider.isLoading) {
      /// If the product provider is loading, show a loading indicator
      /// to indicate that data is being fetched
      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.hasError) {
      /// If there is an error fetching products, show an error message
      /// to inform the user about the issue
      return const Center(child: Text('Error fetching products'));
    }
    if (productProvider.products.isEmpty) {
      /// If there are no products available, show a message indicating that
      /// no products are available
      return const Center(child: Text('No products available'));
    }

    int columnCount = screenWidth > 1000 ? 4 : screenWidth > 600 ? 3 : 2;
    /// Determine the number of columns based on the screen width
    /// 4 columns for large screens, 3 for medium screens, and 2 for small screens

    return Center(
      /// Center the grid within the available space
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GridView.builder(
            /// Create a grid view to display the products
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemCount: productProvider.products.length,
            /// Set the number of items in the grid to the number of products
            itemBuilder: (context, index) {
              /// Build each item in the grid using the ProductCard widget
              final product = productProvider.products[index];
              /// Get the product data from the provider
              return ProductCard(product: product);
              /// Pass the product data to the ProductCard widget
            },
          ),
        ),
      ),
    );
  }
}
