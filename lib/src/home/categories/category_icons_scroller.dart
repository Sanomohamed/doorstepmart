// ignore_for_file: deprecated_member_use
import 'package:doorstepmart/src/home/categories/category_icon_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryIconScroller extends StatelessWidget {
  const CategoryIconScroller({super.key});

  static final List<Map<String, dynamic>> categories = [
    {'name': 'Fruits', 'icon': FontAwesomeIcons.appleAlt},
    {'name': 'Vegetables', 'icon': FontAwesomeIcons.carrot},
    {'name': 'Poultry', 'icon': FontAwesomeIcons.egg},
    {'name': 'Drinks', 'icon': FontAwesomeIcons.wineBottle},
    {'name': 'Grains', 'icon': FontAwesomeIcons.seedling},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth > 1000 ? 28.0 : screenWidth > 600 ? 24.0 : 20.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryIconCard(
                name: category['name'],
                icon: category['icon'],
                iconSize: iconSize,
              );
            },
          ),
        ),
      ),
    );
  }
}
