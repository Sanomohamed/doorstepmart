import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;
  final String shopId; // ✅ Added shopId field

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.shopId, // ✅ Ensure shopId is required
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void add(CartItem item) {
    for (var cartItem in _items) {
      if (cartItem.name == item.name && cartItem.shopId == item.shopId) {
        cartItem.quantity += 1;
        notifyListeners();
        return;
      }
    }

    _items.add(item);
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    item.quantity -= 1;
    if (item.quantity == 0) {
      remove(item);
    }
    notifyListeners();
  }

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get tax => totalPrice * 0.05;
  double get serviceFee => 2.0;
  double get total => totalPrice + tax + serviceFee;

  /// ✅ **Group items by shopId for checkout process**
  Map<String, List<CartItem>> getGroupedByShop() {
    Map<String, List<CartItem>> groupedItems = {};
    for (var item in _items) {
      if (!groupedItems.containsKey(item.shopId)) {
        groupedItems[item.shopId] = [];
      }
      groupedItems[item.shopId]!.add(item);
    }
    return groupedItems;
  }
}
