import 'package:doorstepmart/src/cart/shop_cart.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/shop.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Fruits', 'icon': FontAwesomeIcons.appleAlt},
      {'name': 'Vegetables', 'icon': FontAwesomeIcons.carrot},
      {'name': 'Dairy', 'icon': FontAwesomeIcons.cheese},
      {'name': 'Meat', 'icon': FontAwesomeIcons.drumstickBite},
      {'name': 'Fish', 'icon': FontAwesomeIcons.fish},
      {'name': 'Frozen Foods', 'icon': FontAwesomeIcons.snowflake},
      {'name': 'Drinks', 'icon': FontAwesomeIcons.wineBottle},
      {'name': 'Sauces', 'icon': FontAwesomeIcons.bottleDroplet},
      {'name': 'Condiments', 'icon': FontAwesomeIcons.pepperHot},
      {'name': 'Others', 'icon': Icons.category},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MiniMartPage(),
                  ),
                );
              },
              child: Row(
                children: const [
                  Text(
                    'View more',
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return ProductCard(
                icon: categories[index]['icon'],
                name: categories[index]['name'],
              );
            },
          ),
        ),
      ],
    );
  }
}