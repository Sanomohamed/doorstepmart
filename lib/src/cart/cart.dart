import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/emergency/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
         backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      ),
       backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                       color: const Color.fromARGB(157, 155, 235, 152), // Set the background color of the card
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Image.asset(item.image.toString(), width: 50, height: 50),
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${item.price}'),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    Provider.of<CartModel>(context, listen: false).decreaseQuantity(item);
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    Provider.of<CartModel>(context, listen: false).increaseQuantity(item);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<CartModel>(context, listen: false).remove(item);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 142, 223, 149),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? () {
                          Fluttertoast.showToast(
                            msg: "Add items to the cart to checkout",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CheckoutPage()),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 110, 146, 111),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.black),
                  ),
                 ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
                        Text('Tax: \$${cart.tax.toStringAsFixed(2)}'),
                        Text('Service Fee: \$${cart.serviceFee.toStringAsFixed(2)}'),
                        Divider(),
                        Text(
                          'Grand Total: \$${cart.Total.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }
}