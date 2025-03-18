import 'package:doorstepmart/services/auth_service.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/account/ActivitySection.dart';
import 'package:doorstepmart/src/account/ProfileSection.dart';
import 'package:doorstepmart/src/account/PurchaseSection.dart';
import 'package:doorstepmart/src/account/SupportSection.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService authService = AuthService();
  bool _isLoggingOut = false;

  // ✅ Logout Function
  void _logout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await authService.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
      }
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ✅ Profile Section
          const ProfileSection(),
          const SizedBox(height: 16.0),

          // ✅ Purchase Section
          const PurchaseSection(),
          const SizedBox(height: 16.0),

          // ✅ Activity Section
          const ActivitySection(),
          const SizedBox(height: 16.0),

          // ✅ Support Section
          const SupportSection(),
          const SizedBox(height: 16.0),

          // ✅ Divider for Separation
          const Divider(thickness: 4),

          // ✅ More Products Section Title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'More Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ Product Grid Section (Dynamic Fetching)
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              if (productProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (productProvider.hasError) {
                return const Center(child: Text('Failed to load products'));
              } else if (productProvider.products.isEmpty) {
                return const Center(child: Text('No products available'));
              }
              return const ProductGrid(); // Displays the dynamic product grid
            },
          ),

          const SizedBox(height: 20),

          // ✅ Logout Button
          ElevatedButton.icon(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: _isLoggingOut
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : const Icon(Icons.logout, color: Colors.white),
            label: Text(
              _isLoggingOut ? 'Logging out...' : 'Logout',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
