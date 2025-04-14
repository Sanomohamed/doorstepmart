import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/shop/product_grid/productcart.dart';   //importing the necessary packages and files
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductProvider>(context);   // Using Provider to access the ProductProvider instance
   
    final screenWidth = MediaQuery.of(context).size.width;    // Getting the screen width to determine the number of columns in the grid
    
    int columnCount = screenWidth > 1000 ? 4 : screenWidth > 600 ? 3 : 2; 

    if (productProvider.isLoading) {

      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.hasError) {
     
      return const Center(child: Text('Error fetching products'));
    }
    if (productProvider.products.isEmpty) {
    
      return const Center(child: Text('No products available'));
    }

    return Center(

      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
              return ProductCard(product: product);
            },
          ),
        ),
      ),
    );
  }
}
