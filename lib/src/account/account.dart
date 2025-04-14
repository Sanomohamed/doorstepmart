import 'package:doorstepmart/src/account/profile_section.dart';
import 'package:doorstepmart/src/shop/product_grid/productgrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/account/ActivitySection.dart';
import 'package:doorstepmart/src/account/PurchaseSection.dart';
import 'package:doorstepmart/src/account/SupportSection.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
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
        ],
      ),
    );
  }
}
