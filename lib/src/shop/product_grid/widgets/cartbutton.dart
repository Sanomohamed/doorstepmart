import 'package:doorstepmart/src/shop/cart_model.dart';
import'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartButton extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onChanged;

  const AddToCartButton({super.key, required this.product, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        final newItem = CartItem(
          name: product['name'],
          image: (product['imageUrls'] as List?)?.first ?? '',
          price: (product['price'] as num?)?.toDouble() ?? 0.0,
          shopId: product['shopId'] ?? '',
          quantity: 1,
          shopName: product['shopName'] ?? '',
        );

        cartModel.add(newItem);
        onChanged();
        _showUndoToastBottomSheet(context, newItem, cartModel, onChanged);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

 void _showUndoToastBottomSheet(
  BuildContext parentContext,
  CartItem addedItem,
  CartModel cartModel,
  VoidCallback onChanged,
) {
  showModalBottomSheet(
    context: parentContext,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bottomSheetContext) {
      // ✅ Auto-dismiss after 3 seconds using local modal context
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.of(bottomSheetContext).canPop()) {
          Navigator.of(bottomSheetContext).pop();
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
                    cartModel.remove(addedItem);
                    Navigator.of(bottomSheetContext).pop(); // ✅ close with local context
                    onChanged();
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
}