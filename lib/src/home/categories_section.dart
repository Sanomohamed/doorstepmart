import 'package:doorstepmart/src/cart/shop_cart.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/shop.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      // ignore: deprecated_member_use
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
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
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
       SizedBox(
        height: 110, // Slightly increased for better touch area
        child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16), // Added padding for better spacing
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12), // Slightly increased spacing
        itemBuilder: (context, index) {
         return Container(
          decoration: BoxDecoration(
          color: const Color.fromARGB(71, 131, 187, 117),
          borderRadius: BorderRadius.circular(20), // Smoother rounded corners
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: const Color.fromARGB(176, 0, 0, 0).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: ProductCard(
          icon: categories[index]['icon'],
          name: categories[index]['name'],
        ),
      );
    },
  ),
),
      ],
    );
  }
}