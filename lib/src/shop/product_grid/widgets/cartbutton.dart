import 'package:doorstepmart/src/shop/product_grid/widgets/undo_toast_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
//importing the necessary packages and files for the AddToCartButton widget

class AddToCartButton extends StatelessWidget {
  /// A button that adds a product to the cart and shows a toast with an undo option.
  final Map<String, dynamic> product;
  /// The product to be added to the cart.
  final VoidCallback onChanged;
  /// A callback function to be called when the cart is changed.

  const AddToCartButton({super.key, required this.product, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    /// Builds the AddToCartButton widget.
    /// Uses the Provider package to access the CartModel.
    final cartModel = Provider.of<CartModel>(context, listen: false);

    return ElevatedButton(
      /// An ElevatedButton that adds the product to the cart.
      onPressed: () {
        /// When the button is pressed, it creates a new CartItem with the product details.
        /// It then adds the item to the cart and shows a toast with an undo option.
        final newItem = CartItem(
          /// Creating a new CartItem with the product details
          name: product['name'],
          image: (product['imageUrls'] as List?)?.first ?? '',
          price: (product['price'] as num?)?.toDouble() ?? 0.0,
          shopId: product['shopId'] ?? '',
          quantity: 1,
          shopName: product['shopName'] ?? '',
        );

        cartModel.add(newItem);
        /// Adding the new item to the cart model
        /// Calling the onChanged callback to notify any listeners about the change
        onChanged();

        showUndoToastBottomSheet(
          /// Showing a toast with an undo option
          context: context,
          ///// The toast will show the name of the added item and an undo button
          addedItem: newItem,
          onUndo: () {
            /// If the undo button is pressed, it removes the item from the cart and calls the onChanged callback
            cartModel.remove(newItem);
            onChanged();
            
          },
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 14)),
      /// The button will have a green background color and white text
    );
  }
}
