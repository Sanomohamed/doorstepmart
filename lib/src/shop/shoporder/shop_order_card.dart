import 'package:doorstepmart/src/shop/shoporder/management/order_detail.dart';  //importing necessary packages
import 'package:flutter/material.dart';

class ShopOrderCard extends StatelessWidget {

  final Map<String, dynamic> order;
  final String orderId;

  const ShopOrderCard({
    super.key,
    required this.order,
    required this.orderId,
  });
//build method to create the UI of the ShopOrderCard widget. It uses the order details to populate the card's content.
  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? 'Pending';
    final userName = order['userName'] ?? 'N/A';
    final totalAmount = order['totalAmount'] ?? 0;
// This padding is used to create space between the cards in the list.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15), 
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell( // InkWell widget to make the card tappable
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderPage(orderId: orderId)), 
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: $userName',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Order ID: $orderId', 
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Amount: RM$totalAmount',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Status: $status',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
