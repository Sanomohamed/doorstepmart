import 'package:doorstepmart/src/shop/header/header_background_image.dart';
import 'package:doorstepmart/src/shop/header/icon_button.dart';
import 'package:doorstepmart/src/shop/header/shop_name_display.dart';
import 'package:doorstepmart/src/shop/shoporder/order_managment.dart';
import 'package:doorstepmart/src/setup/create_shop_page.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//importing the necessary packages and files for the HeaderSection widget

class HeaderSection extends StatefulWidget {
  // This widget is used to create the header section of the shop page.
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  // This stateful widget fetches the shop name from Firestore and displays it in the header.
  String shopName = "Loading...";
  // Initializing the shopName variable to "Loading..."
  // This variable will be updated with the actual shop name once it is fetched from Firestore.

  @override
  void initState() {
    // This method is called when the widget is first created.
    // It is used to perform any initialization tasks, such as fetching data from Firestore.
    super.initState();
    _fetchShopName();
  }

  Future<void> _fetchShopName() async {
    // This method fetches the shop name from Firestore based on the current user's ID.
    // It uses the FirebaseAuth instance to get the current user's ID and then queries the Firestore database.
    try {
      final user = FirebaseAuth.instance.currentUser;
      // Getting the current user from FirebaseAuth
      if (user == null) return;
      // If the user is null, return early to avoid unnecessary database calls.
      // Querying the Firestore database to get the shop name associated with the current user
      final snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      setState(() {
        // Updating the state with the fetched shop name
        // If the shop name is not found, set it to "Unknown Shop"
        shopName = snapshot.docs.isNotEmpty
            ? snapshot.docs.first['shopName'] ?? "Unknown Shop"
            : "No Shop Found";
      });
    } catch (e) {
      // If there is an error while fetching the shop name, set it to "Error Loading Shop"
      // This could be due to network issues or Firestore permission errors.
      setState(() => shopName = "Error Loading Shop");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method builds the UI of the HeaderSection widget.
    // It uses a Stack widget to overlay the header background image and other UI elements.
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopOrderManagementPage()),
                ),
              ),
            ],
          ),
        ),
        ShopNameDisplay(shopName: shopName),
        // This widget displays the shop name in the header section.
        Positioned(
          bottom: 10,
          right: 10,
          child: CircleIconButton(
            icon: Icons.favorite,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateShopPage()),
            ),
          ),
        ),
      ],
    );
  }
}
