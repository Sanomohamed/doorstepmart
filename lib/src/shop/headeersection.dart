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
        // ✅ Background Image with Gradient Overlay
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  // ignore: deprecated_member_use
                  Colors.black.withOpacity(0.6), // Darker at the bottom for better contrast
                  Colors.transparent, // Fades into the image
                ],
              ),
            ),
          ),
        ),

        // ✅ Back Button
        Positioned(
          top: 30,
          left: 10,
          child: _buildCircleIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Landing()),
              );
            },
          ),
        ),

        // ✅ Right-side Action Buttons (Search & Cart)
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              _buildCircleIconButton(
                icon: Icons.search,
                onPressed: () {
                  // Handle search action
                },
              ),
              const SizedBox(width: 8),
              _buildCircleIconButton(
                // ignore: deprecated_member_use
                icon: FontAwesomeIcons.shoppingCart,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
            ],
          ),
        ),

        // ✅ Store Name Text
        Positioned(
          bottom: 20,
          left: 15,
          child: const Text(
            'MINI Mart',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // ✅ Favorite Button (Floating Circle)
        Positioned(
          bottom: 10,
          right: 10,
          child: _buildCircleIconButton(
            icon: Icons.favorite,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ Helper Widget for Modern Circle Buttons
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
    Color backgroundColor = Colors.black54,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 26, color: iconColor),
        ),
      ),
    );
  }
}
