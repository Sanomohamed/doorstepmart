import 'package:doorstepmart/src/cart/shop_cart.dart';
import 'package:doorstepmart/src/setup/createshoppage.dart';
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
        // ✅ Category Title & "View More" Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateShopPage()),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                 
                ),
                child: Row(
                  children: const [
                    Text(
                      'View more',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),

        // ✅ Category List with Modern UI
        SizedBox(
          height: 120, // Slightly increased height for better touch area
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildCategoryCard(
                icon: categories[index]['icon'],
                name: categories[index]['name'],
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ Category Card UI
  Widget _buildCategoryCard({required IconData icon, required String name}) {
    return Container(
      width: 110,
      height: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(166, 119, 171, 138), // Fresh modern green shade
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 48,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color.fromARGB(211, 29, 29, 29)),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}