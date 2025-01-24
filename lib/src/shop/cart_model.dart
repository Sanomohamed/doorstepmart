import 'package:flutter/material.dart';

class CartItem{
  final String name;
  final  String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity
  });
}

class CartModel extends ChangeNotifier {

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void add(CartItem item){
    // ignore: non_constant_identifier_names
    for (var CartItem in _items){
      if (CartItem.name == item.name){
        CartItem.quantity+=1;
        notifyListeners();
        return;
      }
    }

    _items.add(item);
    notifyListeners();

  }

  void remove(CartItem item){
    _items.remove(item);
    notifyListeners();
  }

  void increaseQuantity(CartItem item){
    item.quantity+=1;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item){
    item.quantity-=1;
    if (item.quantity == 0){
      remove(item);
    }
    notifyListeners();
  }

  double get totalPrice{
    return _items.fold(0, (sum, item) => sum + (item.price*item.quantity));
  }

  double get tax=> totalPrice* 0.05;
  double get serviceFee => 2.0;
  // ignore: non_constant_identifier_names
  double get Total => totalPrice + tax + serviceFee;
}