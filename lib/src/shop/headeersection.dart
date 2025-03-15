import 'package:flutter/material.dart';
import 'package:doorstepmart/src/favorite/favorite_page.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:doorstepmart/src/cart/cart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Landing()));
            },
          ),
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, size: 30, color: Colors.white),
                onPressed: () {
                  // Handle search action
                },
              ),
              IconButton(
                // ignore: deprecated_member_use
                icon: const Icon(FontAwesomeIcons.shoppingCart, size: 30, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 10,
          child: const Text(
            'MINI Mart',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.favorite, size: 28, color: Colors.red),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
              },
            ),
          ),
        ),
      ],
    );
  }
}
