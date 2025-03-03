import 'package:doorstepmart/src/cart/shop_cart.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/shop.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
      final List<String> categoryNames = [
      'Fruits',
      'Vegetables',
      'Dairy',
      'Meat',
      'Fish',
      'Frozen Foods',
      'Drinks',
      'Sauces',
      'Condiments',
      'Others'
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
            itemCount: 10, // Number of products
            separatorBuilder: (_, __) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              // Use different icons for the ProductCard
              IconData icon = Icons.category; // Default icon
               switch (index) {
                case 0:
                  // ignore: deprecated_member_use
                  icon = FontAwesomeIcons.appleAlt; // Fruits
                  break;
                case 1:
                  icon = FontAwesomeIcons.carrot; // Vegetables
                  break;
                case 2:
                  icon = FontAwesomeIcons.cheese; // Dairy
                  break;
                case 3:
                  icon = FontAwesomeIcons.drumstickBite; // Meat
                  break;
                case 4:
                  icon = FontAwesomeIcons.fish; // Fish
                  break;
                case 5:
                  icon = FontAwesomeIcons.snowflake; // Frozen foods
                  break;
                case 6:
                  icon = FontAwesomeIcons.wineBottle; // Drinks
                  break;
                case 7:
                  icon = FontAwesomeIcons.bottleDroplet; // Sauces
                  break;
                case 8:
                  icon = FontAwesomeIcons.pepperHot; // Condiments
                  break;
                default:
                  icon = Icons.category; // Default icon
              }
              return ProductCard(
                icon: icon,
                name:  categoryNames[index],
              );
            },
          ),
        ),
      ],
    );
  }
}