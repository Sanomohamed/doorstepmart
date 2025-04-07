import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/shop/product_grid/widgets/cartbutton.dart';
import 'package:doorstepmart/src/shop/product_grid/widgets/cartcontrols.dart';
import 'package:doorstepmart/src/shop/product_grid/widgets/favoritebutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductActionsSection extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductActionsSection({super.key, required this.product});

  @override
  State<ProductActionsSection> createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final String name = widget.product['name'] ?? '';
    final String shopId = widget.product['shopId'] ?? '';

    final CartItem? cartItem = cartModel.items.firstWhere(
      (item) => item.name == name && item.shopId == shopId,
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FavoriteButton(product: widget.product),
          cartItem != null && cartItem.quantity > 0
              ? CartControls(cartItem: cartItem, onChanged: () => setState(() {}))
              : Expanded(
                  child: AddToCartButton(product: widget.product, onChanged: () => setState(() {})),
          ),
        ],
      ),
    );
  }
}
