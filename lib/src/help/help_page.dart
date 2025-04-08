import 'package:doorstepmart/src/help/widget/info_card.dart';
import 'package:doorstepmart/src/help/widget/section_title.dart';
import 'package:doorstepmart/src/help/widget/support_footer.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 236, 208),
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
            children: const [
              SectionTitle("🔎 Overview"),
              InfoCard("DoorstepMart is a mobile marketplace where users can create shops, list products, and sell or buy items directly from each other."),

              SectionTitle("🛍️ Shop Management"),
              InfoCard("- Create your shop from the Profile page.\n- Upload a logo, shop name, city/state, and operating hours.\n- Only one shop per user is allowed."),

              SectionTitle("📦 Product Management"),
              InfoCard("- Add products with up to 5 images, price, description, and category.\n- Edit or delete your products from the Shop panel.\n- Products are linked to your shop automatically."),

              SectionTitle("🛒 Cart & Orders"),
              InfoCard("- Add products to cart.\n- Quantity increases if the same product is added again.\n- Cart groups products by shop.\n- Checkout includes price summary, tax, and service fee."),

              SectionTitle("❤️ Favorites"),
              InfoCard("- Tap the heart icon to add or remove a product from favorites.\n- View all favorites in the dedicated Favorites tab."),

              SectionTitle("👤 Profile"),
              InfoCard("- Update your name, email, phone number, and profile picture.\n- Access Sell functionality and shop creation."),

              SectionTitle("🔧 Technical Info"),
              InfoCard("- Built with Flutter & Firebase.\n- Offline caching for products enabled.\n- Image uploads use Firebase Storage.\n- All data stored in Firestore."),

              SectionTitle("❓ FAQs"),
              InfoCard("Q: Can I have more than one shop?\nA: No, one shop per user.\n\nQ: Can I edit a product after uploading?\nA: Yes, from the Shop panel.\n\nQ: What happens if I delete a product?\nA: It’s permanently removed from the database."),

              SizedBox(height: 25),
              SupportFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
