// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartModel cart;
  final double discount;

  const OrderSummaryWidget({
    super.key,
    required this.cart,
    required this.discount,
  });

  Future<String> fetchShopName(String shopId) async {
    try {
      DocumentSnapshot shopDoc =
          await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
      if (shopDoc.exists) {
        var shopData = shopDoc.data() as Map<String, dynamic>?;
        return shopData?['shopName'] ?? "Unknown Shop";
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }
    return "Unknown Shop";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(249, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(143, 207, 209, 206).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              // Group items by shop
              ..._groupItemsByShop(cart).entries.map((entry) {
                String shopId = entry.key;
                List<CartItem> shopItems = entry.value;

                return FutureBuilder<String>(
                  future: fetchShopName(shopId),
                  builder: (context, snapshot) {
                    String shopName = snapshot.data ?? "Unknown Shop";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: shopItems.length,
                          itemBuilder: (context, index) {
                            final item = shopItems[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: item.image,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                              title: Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'RM${item.price.toStringAsFixed(2)} x ${item.quantity}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              }),

              // Totals
              Text(
                'Total: RM${cart.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (discount > 0)
                Text(
                  'Discount: -RM${discount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              Text(
                'Tax: RM${cart.tax.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Service Fee: RM${cart.serviceFee.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Divider(),
              Text(
                'Grand Total: RM${(cart.totalPrice - discount + cart.tax + cart.serviceFee).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, List<CartItem>> _groupItemsByShop(CartModel cart) {
    final Map<String, List<CartItem>> groupedItems = {};
    for (var item in cart.items) {
      groupedItems[item.shopId] = [...(groupedItems[item.shopId] ?? []), item];
    }
    return groupedItems;
  }
}
