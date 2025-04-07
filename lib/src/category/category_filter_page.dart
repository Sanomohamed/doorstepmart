import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'widgets/category_selector.dart';
import 'widgets/product_grid.dart';

class CategoryFilterPage extends StatefulWidget {
  final String initialCategory;
  const CategoryFilterPage({super.key, required this.initialCategory});

  @override
  _CategoryFilterPageState createState() => _CategoryFilterPageState();
}

class _CategoryFilterPageState extends State<CategoryFilterPage> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 1000
        ? 32.0
        : screenWidth > 600
            ? 24.0
            : 12.0;

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productProvider.hasError) {
      return const Center(child: Text('Error fetching products'));
    }

    final filteredProducts = productProvider.products
        .where((product) => product['category'] == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter by Category"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color:  const Color.fromARGB(192, 210, 219, 214),
        child: Column(
          children: [
            CategorySelector(
              selectedCategory: selectedCategory,
              onCategorySelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            Expanded(
              child: ProductGrid(
                products: filteredProducts,
                horizontalPadding: horizontalPadding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}