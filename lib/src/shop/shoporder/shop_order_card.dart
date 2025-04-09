import 'package:doorstepmart/src/shop/shoporder/management/order_detail.dart';
import 'package:flutter/material.dart';
//importing necessary packages
//for the ShopOrderCard widget, which displays order details in a card format.

class ShopOrderCard extends StatelessWidget {
  // A widget that represents a card displaying order details in the shop management section.
  // It includes the order status, customer name, total amount, and a tap action to view order details.
  final Map<String, dynamic> order;
  // A map containing order details such as status, customer name, and total amount.
  // This map is used to display the order information in the card.
  final String orderId;

  const ShopOrderCard({
    //constructor for the ShopOrderCard widget
    // It takes a map of order details and an order ID as parameters.
    super.key,
    required this.order,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    //build method to create the UI of the ShopOrderCard widget
    // It uses the order details to populate the card's content.
    final status = order['status'] ?? 'Pending';
    final userName = order['userName'] ?? 'N/A';
    final totalAmount = order['totalAmount'] ?? 0;

    return Padding(
      // Padding widget to add space around the card
      // This padding is used to create space between the cards in the list.
      padding: const EdgeInsets.symmetric(vertical: 15), // More padding between cards
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          // InkWell widget to make the card tappable
          // When tapped, it navigates to the OrderPage with the order ID.
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              //navigating to the OrderPage with the order ID
              // This allows the user to view more details about the order.
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
                  'Order ID: $orderId', // Added Order ID display
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
