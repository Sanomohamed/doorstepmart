import 'package:doorstepmart/src/landing.dart';
import 'package:doorstepmart/src/sell/sell.dart';
import 'package:doorstepmart/src/shop/header/header_background_image.dart';
import 'package:doorstepmart/src/shop/header/icon_button.dart';
import 'package:doorstepmart/src/shop/header/shop_name_display.dart';
import 'package:doorstepmart/src/shop/shoporder/order_managment.dart';
import 'package:doorstepmart/src/setup/create_shop_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderSection extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  const HeaderSection({super.key, this.onSearchChanged});

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
    } catch (_) {
      setState(() => shopName = "Error Loading Shop");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HeaderBackgroundImage(),

        // ————————————————————————
        // Top: inline search bar only
        // ————————————————————————
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(30),
            child: TextField(
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search products...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
              ),
            ),
          ),
        ),

        // ————————————————————————
        // Shop name in the center
        // ————————————————————————
        ShopNameDisplay(shopName: shopName),

        // ————————————————————————
        // Bottom right: Add (+) and Cart icons
        // ————————————————————————
        Positioned(
          bottom: 10,
          right: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleIconButton(
                icon: Icons.library_add,
                iconColor: Colors.green,
                backgroundColor: Colors.white,
                onPressed: () {
                  if (shopName == "No Shop Found") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateShopPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellPage(
                          editProduct: {},
                          productData: null,
                          productId: null,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 12),
              CircleIconButton(
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
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShopOrderManagementPage(),
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
