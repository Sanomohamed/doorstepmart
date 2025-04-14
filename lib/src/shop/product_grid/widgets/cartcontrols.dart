import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';              //importing the necessary packages and files
import 'package:provider/provider.dart';

class CartControls extends StatelessWidget {

  final CartItem cartItem;
  final VoidCallback onChanged;

  const CartControls({super.key, required this.cartItem, required this.onChanged});

  @override
  Widget build(BuildContext context) {

    final cartModel = Provider.of<CartModel>(context, listen: false);

    return Row(
      children: [
        GestureDetector(

          onLongPress: () {
            cartModel.remove(cartItem);
            onChanged();
            _showSnackbar(context, '${cartItem.name} removed from cart');
          },

          child: IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
            onPressed: () {
              cartModel.decreaseQuantity(cartItem);
              if (cartItem.quantity <= 1) cartModel.remove(cartItem);
              onChanged();
            },
          ),
        ),
        Text(
          '${cartItem.quantity}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle,
            color: cartItem.quantity >= 10 ? Colors.grey : Colors.green,
          ),
          onPressed: cartItem.quantity >= 10
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 1000)),
    );
  }
}
