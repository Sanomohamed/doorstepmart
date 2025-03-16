import 'package:doorstepmart/src/account/account.dart';
import 'package:doorstepmart/src/home/home.dart';
import 'package:doorstepmart/src/cart/cart.dart';
import 'package:doorstepmart/src/notification/notification_page.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const CartPage(),
    NotificationPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Keeps all pages in memory, only switching visibility
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(110, 55, 218, 63),
        unselectedItemColor: const Color.fromARGB(206, 0, 0, 0),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
        elevation: 25,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 30),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 30),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
