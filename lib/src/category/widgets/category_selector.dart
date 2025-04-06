import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static final List<Map<String, dynamic>> categories = [
    {'name': 'Fruits', 'icon': FontAwesomeIcons.appleAlt},
    {'name': 'Vegetables', 'icon': FontAwesomeIcons.carrot},
    {'name': 'Poultry', 'icon': FontAwesomeIcons.egg},
    {'name': 'Drinks', 'icon': FontAwesomeIcons.wineBottle},
    {'name': 'Others', 'icon': FontAwesomeIcons.boxOpen},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ Make sure all values are doubles
    final double iconSize = screenWidth > 1000
        ? 28.0
        : screenWidth > 600
            ? 24.0
            : 20.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category['name'] == selectedCategory;

              return GestureDetector(
                onTap: () => onCategorySelected(category['name']),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category['icon'],
                        size: iconSize,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        category['name'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: screenWidth > 600 ? 18.0 : 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
