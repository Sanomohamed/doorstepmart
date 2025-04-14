// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteItem product;

  const FavoriteCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildFavoriteCard(),
        _buildDeleteButton(context),
        _buildAddToCartButton(context),
      ],
    );
  }

  Widget _buildFavoriteCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('RM${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                Text(product.shopName, style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 15,
      child: _buildIconButton(Icons.delete, Colors.red, () {
        Provider.of<FavoriteModel>(context, listen: false).remove(product.name);
      }),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: _buildIconButton(Icons.add_shopping_cart, Colors.green, () {
        Provider.of<CartModel>(context, listen: false).add(CartItem(
          name: product.name,
          image: product.image,
          price: product.price,
          quantity: 1,
          shopId: product.shopId,
          shopName: product.shopName,
        ));
      }),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 22,
      child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed),
    );
  }
}