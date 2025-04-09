import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/shop/product_grid/widgets/cartbutton.dart';
import 'package:doorstepmart/src/shop/product_grid/widgets/cartcontrols.dart';
import 'package:doorstepmart/src/shop/product_grid/widgets/favoritebutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
///importing the necessary packages and files

class ProductActionsSection extends StatefulWidget {
  /// A widget that displays action buttons for a product, including
  final Map<String, dynamic> product;
  //defining the product as a final variable of type Map<String, dynamic>
  //to hold the product details

  const ProductActionsSection({super.key, required this.product});

  @override
  State<ProductActionsSection> createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  @override
  Widget build(BuildContext context) {
    /// Build method to create the UI for the ProductActionsSection
    /// using the Provider package to access the CartModel
    final cartModel = Provider.of<CartModel>(context);
    final String name = widget.product['name'] ?? '';
    // Extracting the name of the product from the product map
    // If the name is not found, it defaults to an empty string.
    final String shopId = widget.product['shopId'] ?? '';
    // Extracting the shopId from the product map
    // If the shopId is not found, it defaults to an empty string.

    final CartItem? cartItem = cartModel.items.firstWhere(
      /// Finding the cart item in the cart model that matches the product name and shopId
      (item) => item.name == name && item.shopId == shopId,
      ///// If no matching item is found, it returns a default CartItem with empty values.
      orElse: () => CartItem(
        name: '',
        shopId: '',
        image: '',
        price: 0.0,
        shopName: '',
        quantity: 0,
      ),
    );

    return Padding(
      /// Padding widget to add space around the action buttons
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          FavoriteButton(product: widget.product),
          /// FavoriteButton widget to allow users to add the product to their favorites
          /// and pass the product details to the widget
          cartItem != null && cartItem.quantity > 0
          /// Checking if the cartItem is not null and its quantity is greater than 0
              /// If true, it displays the CartControls widget
              ? CartControls(cartItem: cartItem, onChanged: () => setState(() {}))
              //setState is called to update the UI when the cart item changes
              /// and pass the cartItem details to the widget
              : Expanded(
                  child: AddToCartButton(product: widget.product, onChanged: () => setState(() {})),
                  /// AddToCartButton widget to allow users to add the product to the cart
          ),
        ],
      ),
    );
  }
}
