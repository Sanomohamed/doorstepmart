import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35.0),
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFD2DBD6),
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
        image: AssetImage('assets/image.png'),
        fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color.fromARGB(255, 139, 137, 137).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(1.0), // Increased visibility
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 26, color: Colors.black54),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search for products...',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            // Implement search functionality
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic, size: 24, color: Colors.black54),
                        onPressed: () {
                          // Implement voice search functionality
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Favorite Icon (Bottom Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.9), // Improved contrast
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.heart, size: 28, color: Colors.green),
                  onPressed: () {
                    // Implement favorite functionality
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
