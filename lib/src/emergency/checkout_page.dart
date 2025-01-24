import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _promoCodeController = TextEditingController();
  double _discount = 0.0;
  String _paymentMethod = 'Card';

  void _applyPromoCode(CartModel cart) {
    if (_promoCodeController.text == 'WELCOME' && cart.totalPrice > 20) {
      setState(() {
        _discount = 5.0;
      });
    } else {
      setState(() {
        _discount = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      appBar: AppBar(
        title: const Text('Checkout Page'),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          final double totalWithDiscount = cart.totalPrice - _discount;
          final double grandTotalWithDiscount = totalWithDiscount + cart.tax + cart.serviceFee;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color:const Color.fromARGB(255, 161, 196, 162),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
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
                      // Cart Items
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
                      if (_discount > 0)
                        Text('Discount: -\$${_discount.toStringAsFixed(2)}'),
                      Text('Tax: \$${cart.tax.toStringAsFixed(2)}'),
                      Text('Service Fee: \$${cart.serviceFee.toStringAsFixed(2)}'),
                      const Divider(),
                      Text(
                        'Grand Total: \$${grandTotalWithDiscount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // Coupon/Promo Code
                TextField(
                  controller: _promoCodeController,
                  decoration: InputDecoration(
                    labelText: 'Coupon or Promo Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _applyPromoCode(cart);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 110, 146, 111),
                  ),
                  child: const Text('Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                const SizedBox(height: 16.0),
                // Payment Method
                const Text(
                  'Select Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Card'),
                  leading: Radio(
                    value: 'Card',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value.toString();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('E-Wallet'),
                  leading: Radio(
                    value: 'E-Wallet',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value.toString();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Online Banking'),
                  leading: Radio(
                    value: 'Online Banking',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                // Order Button
                ElevatedButton(
                  onPressed: () {
                    // Handle order action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 110, 146, 111),
                  ),
                  child: const Text(
                    'Order',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}