import 'package:doorstepmart/src/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/sell/sell.dart';
import 'profile_styles.dart';

class ProfileButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;

  const ProfileButtons({
    super.key,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: isLoading ? null : onSave,
          style: buttonStyle(Colors.green),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Save', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
           Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MiniMartPage()),
                  );
          },
          style: buttonStyle(Colors.black),
          child: const Text('MY SHOP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
