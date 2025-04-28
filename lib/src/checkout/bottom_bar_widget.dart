// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/order/order.dart';

class BottomBarWidget extends StatefulWidget {
  final double grandTotalWithDiscount;
  final String paymentMethod;

  const BottomBarWidget({
    super.key,
    required this.grandTotalWithDiscount,
    required this.paymentMethod,
  });

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  bool _isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final address   = cartModel.selectedAddress;
    final isDisabled = _isPlacingOrder
        || cartModel.items.isEmpty
        || address == null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 221, 231, 221),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total payment column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Payment:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              Text(
                'RM${widget.grandTotalWithDiscount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          // Place Order button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isDisabled ? null : () => _handlePlaceOrder(cartModel, address!),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? Colors.grey : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: _isPlacingOrder
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_checkout, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Place Order',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePlaceOrder(CartModel cartModel, Map<String, dynamic> address) async {
    setState(() => _isPlacingOrder = true);
    try {
      if (cartModel.items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cart is empty")),
        );
        return;
      }

      // address is guaranteed non-null here
      await placeOrder(
        context: context,
        cartItems: cartModel.items,
        total: widget.grandTotalWithDiscount,
        paymentMethod: widget.paymentMethod,
        deliveryAddress: address,
      );

      cartModel.clearCart();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/PurchaseHistory');
    } catch (e) {
      // handle error if needed
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }
}
