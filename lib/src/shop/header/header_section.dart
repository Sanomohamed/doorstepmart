import 'package:doorstepmart/src/sell/sell.dart';
import 'package:doorstepmart/src/shop/header/header_background_image.dart';
import 'package:doorstepmart/src/shop/header/icon_button.dart';
import 'package:doorstepmart/src/shop/header/shop_name_display.dart';
import 'package:doorstepmart/src/shop/shoporder/order_managment.dart';   //importing the necessary packages and files
import 'package:doorstepmart/src/setup/create_shop_page.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String shopName = "Loading...";
  
  @override
  void initState() {
    super.initState();
    _fetchShopName();
  }
// This method fetches the shop name from Firestore based on the current user's ID.
  Future<void> _fetchShopName() async {
   
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
    
      final snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      setState(() {
        shopName = snapshot.docs.isNotEmpty
            ? snapshot.docs.first['shopName'] ?? "Unknown Shop"
            : "No Shop Found";
      });
    } catch (e) {
      setState(() => shopName = "Error Loading Shop");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HeaderBackgroundImage(),
        Positioned(
          top: 30,
          left: 10,
          child: CircleIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Landing()),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              CircleIconButton(icon: Icons.search, onPressed: () {}),
              const SizedBox(width: 8),
           CircleIconButton(
             // ignore: deprecated_member_use
           icon: FontAwesomeIcons.shoppingCart,
           onPressed: shopName == "No Shop Found"
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No shop found. Please create a shop first.",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            : () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopOrderManagementPage()),
                ),
              ),
            ],
          ),
        ),
        ShopNameDisplay(shopName: shopName),
       
        Positioned(
          bottom: 10,
          right: 10,
          child: CircleIconButton(
            icon: Icons.library_add,
            iconColor: Colors.green,
            backgroundColor: Colors.white,
            onPressed: () {
              if (shopName == "No Shop Found") {
                // Redirect to Sell Page if no shop exists
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (_) => const CreateShopPage()),
                 
                );
              } else {
                // Redirect to Create Shop Page if a shop exists
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (_) => const SellPage(editProduct: {}, productData: null, productId: null)),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
