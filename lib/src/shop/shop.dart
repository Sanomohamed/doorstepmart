import 'package:doorstepmart/src/shop/headeersection.dart';
import 'package:doorstepmart/src/shop/offersection.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';
import 'package:flutter/material.dart';

class MiniMartPage extends StatelessWidget {
  const MiniMartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {'name': 'Coca Cola', 'image': 'assets/image.png', 'price': 3.50},
      {'name': 'Pepsi', 'image': 'assets/image.png', 'price': 3.00},
      {'name': 'drink', 'image': 'assets/image.png', 'price': 3.10},
      {'name': 'vegetable', 'image': 'assets/image.png', 'price': 3.20},
      {'name': 'fruit', 'image': 'assets/image.png', 'price': 3.30},
      {'name': 'apple', 'image': 'assets/image.png', 'price': 3.40},
      {'name': 'banana', 'image': 'assets/image.png', 'price': 3.45},
      {'name': 'vegetables', 'image': 'assets/image.png', 'price': 3.20},
      {'name': 'fruits', 'image': 'assets/image.png', 'price': 3.30},
      {'name': 'apples', 'image': 'assets/image.png', 'price': 3.40},
      {'name': 'bananas', 'image': 'assets/image.png', 'price': 3.45},
      {'name': 'redbull', 'image': 'assets/image.png', 'price': 4.45},
      {'name': 'meat', 'image': 'assets/image.png', 'price': 2.20},
      {'name': 'rice', 'image': 'assets/image.png', 'price': 1.30},
      {'name': 'drink', 'image': 'assets/image.png', 'price': 2.40},
      {'name': 'ananas', 'image': 'assets/image.png', 'price': 6.45},
      // Add more products here
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 182, 169),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 10),
            const OfferSection(),
            const SizedBox(height: 10),
            ProductGrid(products: products),
          ],
        ),
      ),
    );
  }
}