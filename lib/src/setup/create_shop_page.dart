import 'dart:io';
import 'package:doorstepmart/services/shop_service.dart';
import 'package:doorstepmart/src/setup/shop_form.dart';
import 'package:flutter/material.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  _CreateShopPageState createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  bool _isLoading = false;

 Future<void> _handleSubmit(
  String name,
  String state,
  String city,
  File? image,
  List<String> days,
  TimeOfDay? opening,
  TimeOfDay? closing,
) async {
  setState(() => _isLoading = true);

  try {
    await ShopServices.createShop(context, name, state, city, image, days, opening, closing); // 🔹 Pass context
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shop created successfully')));
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Shop')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ShopForm(onSubmit: _handleSubmit, isLoading: _isLoading),
      ),
    );
  }
}
