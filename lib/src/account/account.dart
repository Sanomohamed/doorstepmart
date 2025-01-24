import 'package:doorstepmart/src/account/ActivitySection.dart';
import 'package:doorstepmart/src/account/ProfileSection.dart';
import 'package:doorstepmart/src/account/PurchaseSection.dart';
import 'package:doorstepmart/src/account/SupportSection.dart';
import 'package:flutter/material.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ProfileSection(),
          SizedBox(height: 16.0),
          PurchaseSection(),
          SizedBox(height: 16.0),
          ActivitySection(),
          SizedBox(height: 16.0),
          SupportSection(),
          Divider(),
          Text(
            'More Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
        //  ProductGrid(itemCount: 10), // Replace with actual product count
          SizedBox(height: 16.0),
         // LogoutButton(),
        ],
      ),
    );
  }
}