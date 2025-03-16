import 'package:flutter/material.dart';
import 'package:doorstepmart/src/favorite/favorite_page.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 35,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Section Title
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

            // ✅ Favorite Option
            _buildActivityItem(
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
        SizedBox(height: 15),
            // ✅ Recently Viewed Option
            _buildActivityItem(
              icon: Icons.remove_red_eye,
              text: 'Recently Viewed',
              color: Colors.blueAccent,
              onTap: () {
                // Handle recently viewed action
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Custom ListTile with modern styling
  Widget _buildActivityItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.white,
      onTap: onTap,
    );
  }
}
