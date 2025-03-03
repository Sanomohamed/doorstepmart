import 'package:doorstepmart/src/shop/shop.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final IconData icon;
  final String name;

  const ProductCard({required this.icon, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  icon,
                  size: 50,
                  color: const Color.fromARGB(255, 97, 194, 101), // Customize the icon color
                ),
                onPressed: () {
                  Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) => MiniMartPage(),
                            ),
                  );
                  // Add your onPressed code here
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
