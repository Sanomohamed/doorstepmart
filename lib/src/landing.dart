import 'package:doorstepmart/src/account/account.dart';
import 'package:doorstepmart/src/home/home.dart';
import 'package:doorstepmart/src/cart/cart.dart';
import 'package:doorstepmart/src/notification/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Landing extends StatefulWidget {
final Position? position;

 const Landing({super.key, this.position});

  @override
  // ignore: library_private_types_in_public_api
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;
  late PageController _pageController;

  List<Widget> get _pages => [
   Home(),
   CartPage(),
   NotificationPage(),
   //Center(child: Text('Notifications')),
   // Replace with your notifications page
   AccountPage(position: widget.position),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 88, 153, 90),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.account_circle),
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}