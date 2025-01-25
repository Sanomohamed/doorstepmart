import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class OrderSummary extends StatelessWidget {
  final double discount;

  const OrderSummary({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    final double totalWithDiscount = cart.totalPrice - discount;
    final double grandTotalWithDiscount = totalWithDiscount + cart.tax + cart.serviceFee;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 161, 196, 162),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.5),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                leading: Image.asset(item.image, width: 50, height: 50),
                title: Text(item.name),
                subtitle: Text('\$${item.price} x ${item.quantity}'),
              );
            },
          ),
          const Divider(),
          Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
          if (discount > 0)
            Text('Discount: -\$${discount.toStringAsFixed(2)}'),
          Text('Tax: \$${cart.tax.toStringAsFixed(2)}'),
          Text('Service Fee: \$${cart.serviceFee.toStringAsFixed(2)}'),
          const Divider(),
          Text(
            'Grand Total: \$${grandTotalWithDiscount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}