import 'package:doorstepmart/src/account/profile_section.dart';
import 'package:doorstepmart/src/shop/product_grid/productgrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/account/account_page_controller.dart';
import 'package:doorstepmart/src/account/ActivitySection.dart';
//import 'package:doorstepmart/src/account/ProfileSection.dart';
import 'package:doorstepmart/src/account/PurchaseSection.dart';
import 'package:doorstepmart/src/account/SupportSection.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late AccountPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AccountPageController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 210, 219, 214),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ProfileSection(),
          const SizedBox(height: 16.0),
          const PurchaseSection(),
          const SizedBox(height: 16.0),
          const ActivitySection(),
          const SizedBox(height: 16.0),
          const SupportSection(),
          const SizedBox(height: 16.0),
          const Divider(thickness: 4),

          // More Products Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'More Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              if (productProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (productProvider.hasError) {
                return const Center(child: Text('Failed to load products'));
              } else if (productProvider.products.isEmpty) {
                return const Center(child: Text('No products available'));
              }
              return const ProductGrid();
            },
          ),
          const SizedBox(height: 20),

          // Logout Button
Align(
  alignment: Alignment.center, // Align the button to the center
  child: SizedBox(
    width: 200, // Set the desired width
    child: ElevatedButton.icon(
      onPressed: _controller.logout,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      icon: _controller.isLoggingOut
          ? const SizedBox(
              height: 10, width: 1,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Icon(Icons.logout, color: Colors.white),
      label: Text(
        _controller.isLoggingOut ? 'Logging out...' : 'Logout',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}
