import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/product/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoryFilterPage extends StatefulWidget {
  const CategoryFilterPage({super.key});

  @override
  _CategoryFilterPageState createState() => _CategoryFilterPageState();
}

class _CategoryFilterPageState extends State<CategoryFilterPage> {
  String selectedCategory = 'Fruits'; // Default category

  // List of categories with icons
  final List<Map<String, dynamic>> categories = [
    {'name': 'Fruits', 'icon': FontAwesomeIcons.appleAlt},
    {'name': 'Vegetables', 'icon': FontAwesomeIcons.carrot},
    {'name': 'Poultry', 'icon': FontAwesomeIcons.egg},
    {'name': 'Drinks', 'icon': FontAwesomeIcons.wineBottle},
    {'name': 'Others', 'icon': FontAwesomeIcons.boxOpen},
  ];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.hasError) {
      return const Center(child: Text('Error fetching products'));
    }

    // ✅ Filter products based on selected category
    final filteredProducts = productProvider.products
        .where((product) => product['category']?.toString() == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter by Category"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // ✅ Category Selection List
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index]['name'];
                final icon = categories[index]['icon'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.green
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: selectedCategory == category ? Colors.white : Colors.black),
                        const SizedBox(width: 5),
                        Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ Display filtered products
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No products available'))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final imageUrl = (product['imageUrls'] as List<dynamic>?)?.firstOrNull ??
                          'https://via.placeholder.com/150';
                      final name = product['name']?.toString() ?? 'Unknown Product';
                      final price = (product['price'] as num?)?.toDouble() ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ✅ Image Section
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) =>
                                        const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Image.network('https://via.placeholder.com/150',
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),

                              // ✅ Product Details
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'RM${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
