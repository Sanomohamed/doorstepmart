import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/orderlist.dart';  
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
/// Importing necessary packages and files for Firebase, Firestore, and UI components
/// for the Shop Order Management page.

class ShopOrderManagementPage extends StatelessWidget {
  const ShopOrderManagementPage({super.key});

  Future<String?> getShopId() async {
    /// A method to retrieve the shop ID for the current user from Firestore.
    /// It queries the 'shops' collection to find the shop associated with the current user.
    final user = FirebaseAuth.instance.currentUser;
    /// Retrieves the current user from Firebase Authentication.
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('shops')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;

  }

  @override
  Widget build(BuildContext context) {
    /// The build method creates the UI for the Shop Order Management page.
    return FutureBuilder<String?>(
      /// A FutureBuilder widget to asynchronously retrieve the shop ID.
      /// It uses the getShopId method to fetch the shop ID from Firestore.
      future: getShopId(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final shopId = snapshot.data!;
        return Scaffold(
          /// Scaffold widget to create the basic structure of the page.
          appBar: AppBar(
            /// AppBar widget to display the title and background color.
            title: const Text('Shop Order Management'),
            backgroundColor: Colors.green,
          ),

          body: OrderList(shopId: shopId),
          /// OrderList widget to display the list of orders for the shop.
        );
      },
    );
  }
}
