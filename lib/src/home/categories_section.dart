import 'package:doorstepmart/src/category/category_filter_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  static final List<Map<String, dynamic>> categories = [
    {'name': 'Fruits', 'icon': FontAwesomeIcons.appleAlt},
    {'name': 'Vegetables', 'icon': FontAwesomeIcons.carrot},
    {'name': 'Poultry', 'icon': FontAwesomeIcons.egg},
    {'name': 'Drinks', 'icon': FontAwesomeIcons.wineBottle},
    {'name': 'Others', 'icon': FontAwesomeIcons.otter},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double iconSize = screenWidth > 1000
        ? 28.0
        : screenWidth > 600
            ? 24.0
            : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + View More
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    MaterialPageRoute(
                      builder: (context) => const CategoryFilterPage(initialCategory: 'Fruits'),
                    ),
                  );
                },
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
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ✅ Centered Pill-Style Scrollable Categories
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryFilterPage(
                            initialCategory: category['name'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 207, 234, 209),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(category['icon'], size: iconSize, color: Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: screenWidth > 600 ? 18.0 : 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
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
        ),
      ],
    );
  }
}
