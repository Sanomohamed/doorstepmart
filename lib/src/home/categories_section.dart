import 'package:doorstepmart/src/cart/shop_cart.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/shop.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'See more',
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
            itemCount: 10, // Number of products
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              // Use different icons for the ProductCard
              IconData icon = Icons.local_offer; // Default icon
              if (index == 0) icon = Icons.local_grocery_store;
              if (index == 1) icon = Icons.eco;
              return ProductCard(
                icon: icon,
                name: 'shop $index',
              );
            },
          ),
        ),
      ],
    );
  }
}