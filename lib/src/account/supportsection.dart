import 'package:flutter/material.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Support Card Section
        Card(
          elevation: 30,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Title
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 10),
                  child: Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                // ✅ Help Center Option
                _buildSupportItem(
                  icon: Icons.help_center,
                  text: 'Help Center',
                  color: Colors.blue,
                  onTap: () {
                    // Handle Help Center action
                  },
                ),
                 SizedBox(height: 20),
                // ✅ Chat with AI Option
                _buildSupportItem(
                  icon: Icons.chat,
                  text: 'Chat with AI',
                  color: Colors.green,
                  onTap: () {
                    // Handle Chat with AI action
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Custom ListTile with better design
  Widget _buildSupportItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
