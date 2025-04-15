import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/account/account.dart';
import 'package:doorstepmart/src/cart/cart.dart';                        //importing the required packages
import 'package:doorstepmart/src/home/home.dart';
import 'package:doorstepmart/src/notification/notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  static final GlobalKey<_LandingState> landingKey = GlobalKey<_LandingState>();

  const Landing({super.key});
  // This method is used to navigate to a specific tab in the BottomNavigationBar, from outside the Landing widget. It can be called from anywhere in the app.
  static void jumpToTab(int index) {
    landingKey.currentState?._onItemTapped(index);
  }
  @override
  State<Landing> createState() => _LandingState();
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

    Stream<int> _unreadNotificationsCount() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
    }

    Stream<int> _cartItemsCount() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return FirebaseFirestore.instance
      .collection('carts') 
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: StreamBuilder<int>(
              stream: _cartItemsCount(),
              builder: (context, snapshot) {
                final cartCount = snapshot.data ?? 0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart, size: 30),
                    if (cartCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: StreamBuilder<int>(
              stream: _unreadNotificationsCount(),
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications, size: 30),
                    if (unreadCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}