import 'package:doorstepmart/src/account/account.dart';
import 'package:doorstepmart/src/cart/cart.dart';
import 'package:doorstepmart/src/home/home.dart';
import 'package:doorstepmart/src/notification/notification_page.dart';
import 'package:flutter/material.dart';
//importing the required packages

class Landing extends StatefulWidget {
  static final GlobalKey<_LandingState> landingKey = GlobalKey<_LandingState>();

  const Landing({super.key});

  // This method is used to navigate to a specific tab in the BottomNavigationBar
  // from outside the Landing widget. It can be called from anywhere in the app.
  static void jumpToTab(int index) {
    landingKey.currentState?._onItemTapped(index);
  }

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  // This is the index of the currently selected tab in the BottomNavigationBar
  // It is used to keep track of which page to display.
  // The default value is 0, which corresponds to the Home page.
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const CartPage(),
    NotificationPage(),
    const AccountPage(),
  ];

// This method is called when a tab in the BottomNavigationBar is tapped.
// It updates the _selectedIndex state variable to reflect the newly selected tab.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is the main scaffold of the app, which provides a basic structure for the UI.
      // It contains the body and the BottomNavigationBar.
      body: IndexedStack(
        // Using IndexedStack to maintain the state of each page when switching tabs.
        index: _selectedIndex,
        children: _pages,
      ),
        //buttomNavigationBar is a widget that displays a navigation bar at the bottom of the screen.
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(110, 55, 218, 63),
        unselectedItemColor: const Color.fromARGB(206, 0, 0, 0),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
        elevation: 25,
        onTap: _onItemTapped,
        // This method is called when a tab in the BottomNavigationBar is tapped.
        // It updates the _selectedIndex state variable to reflect the newly selected tab.
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
