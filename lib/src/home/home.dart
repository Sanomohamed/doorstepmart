import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/home/categories/categories_section.dart';
import 'package:doorstepmart/src/shop/product_grid/productgrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/home/homeheader.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedOnce) {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
        _hasLoadedOnce = true; // ✅ Ensures Home fetches only once
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFF8F8F8),
      body: Column(
        children: [
          const HomeHeader(),
           const CategoriesSection(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<ProductProvider>(context, listen: false)
                    .fetchProducts(forceRefresh: true);
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          if (productProvider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (productProvider.hasError) {
                            return Center(child: Text("Failed to load products"));
                          }
                          if (productProvider.products.isEmpty) {
                            return const Center(child: Text("No products available."));
                          }
                          return const ProductGrid();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
