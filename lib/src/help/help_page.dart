import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 210, 219, 214),
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle("🔎 Overview"),
              _buildCard("DoorstepMart is a mobile marketplace where users can create shops, list products, and sell or buy items directly from each other."),

              _buildSectionTitle("🛍️ Shop Management"),
              _buildCard("- Create your shop from the Profile page.\n- Upload a logo, shop name, city/state, and operating hours.\n- Only one shop per user is allowed."),

              _buildSectionTitle("📦 Product Management"),
              _buildCard("- Add products with up to 5 images, price, description, and category.\n- Edit or delete your products from the Shop panel.\n- Products are linked to your shop automatically."),

              _buildSectionTitle("🛒 Cart & Orders"),
              _buildCard("- Add products to cart.\n- Quantity increases if the same product is added again.\n- Cart groups products by shop.\n- Checkout includes price summary, tax, and service fee."),

              _buildSectionTitle("❤️ Favorites"),
              _buildCard("- Tap the heart icon to add or remove a product from favorites.\n- View all favorites in the dedicated Favorites tab."),

              _buildSectionTitle("👤 Profile"),
              _buildCard("- Update your name, email, phone number, and profile picture.\n- Access Sell functionality and shop creation."),

              _buildSectionTitle("🔧 Technical Info"),
              _buildCard("- Built with Flutter & Firebase.\n- Offline caching for products enabled.\n- Image uploads use Firebase Storage.\n- All data stored in Firestore."),

              _buildSectionTitle("❓ FAQs"),
              _buildCard("Q: Can I have more than one shop?\nA: No, one shop per user.\n\nQ: Can I edit a product after uploading?\nA: Yes, from the Shop panel.\n\nQ: What happens if I delete a product?\nA: It’s permanently removed from the database."),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Need more help? Contact support@doorstepmart.app',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard(String content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}
