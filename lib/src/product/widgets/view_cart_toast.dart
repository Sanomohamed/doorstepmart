// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/landing.dart';

void showViewCartToastBottomSheet({
  required BuildContext context,
  required String productName,
}) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      Future.delayed(const Duration(seconds: 4), () {
        if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
      });

      return Padding(
        padding: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
        child: Material(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$productName added to cart. View cart?',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close toast
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Future.delayed(const Duration(milliseconds: 200), () {
                     Landing.jumpToTab(1); // Navigate to cart tab
                    });
                  },
                  child: const Text('VIEW', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
