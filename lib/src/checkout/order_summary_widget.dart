import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartModel cart;
  final double discount;

  const OrderSummaryWidget({super.key, required this.cart, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                leading: Image.asset(item.image, width: 100, height: 100),
                title: Text(item.name),
                subtitle: Text('RM${item.price} x ${item.quantity}'),
              );
            },
          ),
          const Divider(),
          Text('Total: RM${cart.totalPrice.toStringAsFixed(2)}'),
          if (discount > 0) Text('Discount: -RM${discount.toStringAsFixed(2)}'),
          Text('Tax: RM${cart.tax.toStringAsFixed(2)}'),
          Text('Service Fee: RM${cart.serviceFee.toStringAsFixed(2)}'),
          const Divider(),
          Text(
            'Grand Total: RM${(cart.totalPrice - discount + cart.tax + cart.serviceFee).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}