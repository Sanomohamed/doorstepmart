import 'package:doorstepmart/src/favorite/favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:doorstepmart/src/cart/cart.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 50, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Landing()));
            },
          ),
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, size: 40, color: Colors.white),
                onPressed: () {
                  // Handle search action
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite, size: 40, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                },
              ),
            ],
          ),
        ),

        
        Positioned(
          bottom: 10,
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
          bottom: 2,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: IconButton(
              icon: const Icon(Icons.info, size: 30, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage()));
              },
            ),
          ),
        ),
      ],
    );
  }
}