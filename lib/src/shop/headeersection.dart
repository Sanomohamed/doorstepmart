import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doorstepmart/src/favorite/favorite_page.dart';
import 'package:doorstepmart/src/landing.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String shopName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchShopName();
  }

  // ✅ Fetch Shop Name from Firestore based on Logged-in User
Future<void> _fetchShopName() async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // ✅ Fetch shop where userId matches logged-in user
    QuerySnapshot shopQuery = await FirebaseFirestore.instance
        .collection('shops')
        .where('userId', isEqualTo: user.uid) // Match logged-in user
        .limit(1)
        .get();

    if (shopQuery.docs.isNotEmpty) {
      DocumentSnapshot shopDoc = shopQuery.docs.first;
      setState(() {
        shopName = shopDoc['shopName'] ?? "Unknown Shop";
      });
    } else {
      setState(() {
        shopName = "No Shop Found";
      });
    }
  } catch (e) {
    print("Error fetching shop name: $e");
    setState(() {
      shopName = "Error Loading Shop";
    });
  }
}


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
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Landing()));
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
                icon: FontAwesomeIcons.shoppingCart,
                onPressed: () {
                  // Navigate to cart/shop management
                },
              ),
            ],
          ),
        ),

        // ✅ Dynamically Display the Shop Name
        Positioned(
          bottom: 20,
          left: 15,
          child: Text(
            shopName, // Display fetched shop name here
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // ✅ Favorite Button
        Positioned(
          bottom: 10,
          right: 10,
          child: _buildCircleIconButton(
            icon: Icons.favorite,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
            },
          ),
        ),
      ],
    );
  }

  // ✅ Helper Widget for Circle Buttons
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
