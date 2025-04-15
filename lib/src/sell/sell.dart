import 'package:flutter/material.dart';
import 'sell_form.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key, required Map<String, dynamic> editProduct, required productData, required productId});

  @override
  // ignore: library_private_types_in_public_api
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sell Product")),
      body: Container(
        color:  const Color.fromARGB(248, 237, 245, 236),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SellForm(),
        ),
      ),
    );
  }
}