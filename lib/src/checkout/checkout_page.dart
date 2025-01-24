import 'package:doorstepmart/src/checkout/orderbutton.dart';
import 'package:doorstepmart/src/checkout/ordersumary.dart';
import 'package:doorstepmart/src/checkout/paymentmethod.dart';
import 'package:doorstepmart/src/checkout/promocode.dart';
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderSummary(discount: _discount),
                const SizedBox(height: 16.0),
                PromoCode(
                  promoCodeController: _promoCodeController,
                  applyPromoCode: _applyPromoCode,
                ),
                const SizedBox(height: 16.0),
                PaymentMethod(
                  paymentMethod: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const OrderButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}