// ignore_for_file: file_names
import 'package:doorstepmart/src/account/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/favorite/favorite_page.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 10),
                  child: Text(
                    'More Activity',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                // Favorite Option
                ActivityItem(
                  icon: Icons.favorite,
                  text: 'My Favorite',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
