import 'package:doorstepmart/src/shop/product_grid/widgets/undo_toast_bottom_sheet.dart';    
import 'package:flutter/material.dart';        //importing the necessary packages and files
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class AddToCartButton extends StatelessWidget {

  final Map<String, dynamic> product;
 
  final VoidCallback onChanged;   /// A callback function to be called when the cart is changed.
  

  const AddToCartButton({super.key, required this.product, required this.onChanged});

  @override
  Widget build(BuildContext context) {
  
    final cartModel = Provider.of<CartModel>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
// Creating a new CartItem with the product details
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
/// Showing a toast with an undo option
        showUndoToastBottomSheet(
          
          context: context,
          addedItem: newItem,
 /// The toast will show the name of the added item and an undo button. If the undo button is pressed, it removes the item from the cart and calls the onChanged callback
          onUndo: () {
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
    );
  }
}
