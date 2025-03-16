import 'package:doorstepmart/services/product.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/home/homeheader.dart';
import 'package:doorstepmart/src/home/categories_section.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HomeHeader(), // ✅ Now correctly positioned at the top

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    const CategoriesSection(),
                    const SizedBox(height: 8.0),

                    // ✅ Uses Consumer to Properly Load Products
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, _) {
                        return productProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const ProductGrid();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
