import 'package:doorstepmart/src/cart/cart_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchShopName(item.shopId),
      builder: (context, snapshot) {
        String shopName = snapshot.data ?? "Unknown Shop";
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                _buildProductImage(),
                const SizedBox(width: 15),
                _buildProductInfo(context,shopName),
                _buildRemoveButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  ///  Product Image
  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: item.image,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }

  //Product Info
  Widget _buildProductInfo(BuildContext context,String shopName) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 5),
          Text('RM${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
          const SizedBox(height: 5),
          Text(shopName, style: const TextStyle(fontSize: 14, color: Colors.blue)),
          _buildQuantityControls(context),
        ],
      ),
    );
  }

  // Quantity Controls
  Widget _buildQuantityControls(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.remove_circle, color: Colors.redAccent), onPressed: () {
          Provider.of<CartModel>(context, listen: false).decreaseQuantity(item);
        }),
        Text('${item.quantity}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle, color: Colors.green), onPressed: () {
          Provider.of<CartModel>(context, listen: false).increaseQuantity(item);
        }),
      ],
    );
  }

  //Remove Button
  Widget _buildRemoveButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () {
        Provider.of<CartModel>(context, listen: false).remove(item);
      },
    );
  }
}
