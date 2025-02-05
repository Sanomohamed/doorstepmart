import 'package:doorstepmart/services/auth_service.dart';
import 'package:doorstepmart/src/account/ActivitySection.dart';
import 'package:doorstepmart/src/account/ProfileSection.dart';
import 'package:doorstepmart/src/account/PurchaseSection.dart';
import 'package:doorstepmart/src/account/SupportSection.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;



class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

final AuthService authService = AuthService();
bool _isLoggingOut = false;

     void _logout() async {
    if (_isLoggingOut) {
      print('Logout already in progress...');
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      print('Attempting to sign out...');
      await authService.signOut();
      print('Sign out successful');
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
      }
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 137, 185, 138),
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
          const Divider(),
          const Text(
            'More Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
        //  ProductGrid(itemCount: 10), // Replace with actual product count
          const SizedBox(height: 16.0),
         // LogoutButton(),
         IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
    );
  }
}