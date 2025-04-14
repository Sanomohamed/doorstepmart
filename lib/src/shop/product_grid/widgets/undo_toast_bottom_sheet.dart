import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
//function to show a bottom sheet with an undo option
 void showUndoToastBottomSheet({
  required BuildContext context,
  required CartItem addedItem,
  required VoidCallback onUndo,
 }) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (BuildContext modalContext) {

      Future.delayed(const Duration(seconds: 3), () {
        // ignore: use_build_context_synchronously
        if (Navigator.of(modalContext).canPop()) {
          // ignore: use_build_context_synchronously
          Navigator.of(modalContext).pop();
        }
      });

      return Padding(

        padding: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${addedItem.name} added to cart',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onUndo();
                    Navigator.of(modalContext).pop();
                  },
                  child: const Text('UNDO', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
