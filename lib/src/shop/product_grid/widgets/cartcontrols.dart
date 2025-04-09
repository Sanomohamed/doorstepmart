import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//importing the necessary packages and files for the CartControls widget

class CartControls extends StatelessWidget {
  /// A widget that displays the controls for a cart item, including quantity and remove options.
  final CartItem cartItem;
  /// The cart item to be controlled.
  final VoidCallback onChanged;
  /// A callback function to be called when the cart is changed.

  const CartControls({super.key, required this.cartItem, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    /// Builds the CartControls widget.
    /// Uses the Provider package to access the CartModel.
    final cartModel = Provider.of<CartModel>(context, listen: false);

    return Row(
      /// A Row widget that contains the controls for the cart item.
      children: [
        GestureDetector(
          /// A GestureDetector that detects long press and tap events.
          onLongPress: () {
            /// When the item is long pressed, it shows a snackbar with an option to remove the item.
            cartModel.remove(cartItem);
            onChanged();
            _showSnackbar(context, '${cartItem.name} removed from cart');
          },
          child: IconButton(
            /// An IconButton that removes the item from the cart.
            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
            onPressed: () {
              cartModel.decreaseQuantity(cartItem);
              if (cartItem.quantity <= 1) cartModel.remove(cartItem);
              onChanged();
            },
          ),
        ),
        Text(
          /// A Text widget that displays the quantity of the cart item.
          '${cartItem.quantity}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          /// An IconButton that increases the quantity of the cart item.
          icon: Icon(
            Icons.add_circle,
            color: cartItem.quantity >= 10 ? Colors.grey : Colors.green,
          ),
          onPressed: cartItem.quantity >= 10
              /// If the quantity is 10 or more, the button is disabled and does nothing.
              ? null
              : () {
                  cartModel.increaseQuantity(cartItem);
                  onChanged();
                },
        ),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    /// A helper function that shows a snackbar with a message.
    /// It uses the ScaffoldMessenger to display the snackbar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 1000)),
    );
  }
}
