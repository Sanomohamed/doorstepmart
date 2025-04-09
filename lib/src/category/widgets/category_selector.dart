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
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category['name'] == selectedCategory;

              return GestureDetector(
                onTap: () => onCategorySelected(category['name']),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Circle background with icon
                      Container(
                        width: iconSize + 60, // Circle size
                        height: iconSize + 60,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            category['icon'],
                            size: iconSize+25,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Space between icon and text
                      // Category name
                      Text(
                        category['name'],
                        style: TextStyle(
                          color: isSelected ? Colors.green : Colors.black,
                          fontSize: screenWidth > 600 ? 20.0 : 18.0,
                          fontWeight: FontWeight.bold,
                        
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
