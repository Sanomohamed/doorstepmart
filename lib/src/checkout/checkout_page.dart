import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_summary_widget.dart';
import 'promo_code_widget.dart';
import 'payment_method_widget.dart';
import 'bottom_bar_widget.dart';

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
    if (_promoCodeController.text.trim().toUpperCase() == 'WELCOME' && cart.totalPrice > 20) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Consumer<CartModel>(
          builder: (context, cart, child) {
            return Text(
              'Checkout (${cart.items.length} items)',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          final double totalWithDiscount = cart.totalPrice - _discount;
          final double grandTotalWithDiscount = totalWithDiscount + cart.tax + cart.serviceFee;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderSummaryWidget(cart: cart, discount: _discount),
                      const SizedBox(height: 16.0),
                      PromoCodeWidget(
                        promoCodeController: _promoCodeController,
                        applyPromoCode: () => _applyPromoCode(cart),
                      ),
                      const SizedBox(height: 16.0),
                      PaymentMethodWidget(
                        paymentMethod: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: BottomBarWidget(grandTotalWithDiscount: grandTotalWithDiscount),
              ),
            ],
          );
        },
      ),
    );
  }
}
