import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/home/beverage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/home/homeheader.dart';
import 'package:doorstepmart/src/home/locationsection.dart';
import 'package:doorstepmart/src/home/categories_section.dart';
import 'package:doorstepmart/src/home/promotionsection.dart';
import 'package:doorstepmart/src/home/beveragesection.dart';
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Align(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                const HomeHeader(),
                const SizedBox(height: 8.0),
                const LocationSection(),
                const SizedBox(height: 8.0),
                const CategoriesSection(),
                const SizedBox(height: 8.0),
                const PromotionSection(),
                const SizedBox(height: 8.0),
                const BeverageSection(),
                const SizedBox(height: 8.0),

                // **Using Consumer for ProductGrid**
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
    );
  }
}
