import 'package:doorstepmart/src/category/category_filter_page.dart';
import 'package:flutter/material.dart';

class CategoryIconCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final double iconSize;

  const CategoryIconCard({
    super.key,
    required this.name,
    required this.icon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryFilterPage(initialCategory: name),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize + 60,
              height: iconSize + 60,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, size: iconSize + 25, color: const Color.fromARGB(255, 115, 202, 115)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: iconSize > 600 ? 20.0 : 18.0,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
