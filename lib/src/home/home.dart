import 'package:doorstepmart/src/emergency/beverage.dart';
import 'package:doorstepmart/src/home/beveragesection.dart';
import 'package:doorstepmart/src/home/categories_section.dart';
import 'package:doorstepmart/src/home/homeheader.dart';
import 'package:doorstepmart/src/home/locationsection.dart';
import 'package:doorstepmart/src/home/promotionsection.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

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
      backgroundColor: const Color(0xFFD2DBD6),
      body: Align(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
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
                ProductGridSection(products: products),
              ],
            ),
          ),
        ),
      ),
    );
  }
}