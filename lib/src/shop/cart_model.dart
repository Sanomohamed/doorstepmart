import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;
  final String shopId; // ✅ Keep shopId for grouping

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.shopId,
  });

  /// ✅ Convert `CartItem` to Firestore-friendly format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'shopId': shopId,
    };
  }

  /// ✅ Create `CartItem` from Firestore document
  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      name: data['name'],
      image: data['image'],
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'],
      shopId: data['shopId'],
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  /// ✅ Firestore reference for the cart
  DocumentReference<Map<String, dynamic>> get cartRef {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance.collection('carts').doc(user.uid);
  }

  /// ✅ Fetch cart from Firestore when user logs in
  Future<void> fetchCart() async {
    try {
      var cartDoc = await cartRef.get();
      if (cartDoc.exists) {
        var cartData = cartDoc.data();
        if (cartData != null && cartData.containsKey('items')) {
          _items.clear();
          _items.addAll(
            (cartData['items'] as List<dynamic>).map((item) => CartItem.fromMap(item)),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("🔥 Error fetching cart: $e");
    }
  }

  /// ✅ Save cart to Firestore
  Future<void> saveCart() async {
    try {
      await cartRef.set({
        'items': _items.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      debugPrint("🔥 Error saving cart: $e");
    }
  }

  /// ✅ Add item to cart
  void add(CartItem item) {
    for (var cartItem in _items) {
      if (cartItem.name == item.name && cartItem.shopId == item.shopId) {
        cartItem.quantity += 1;
        notifyListeners();
        saveCart(); // ✅ Save to Firestore
        return;
      }
    }

    _items.add(item);
    notifyListeners();
    saveCart(); // ✅ Save to Firestore
  }

  /// ✅ Remove item from cart
  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
    saveCart(); // ✅ Save to Firestore
  }

  /// ✅ Increase item quantity
  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
    saveCart(); // ✅ Save to Firestore
  }

  /// ✅ Decrease item quantity
  void decreaseQuantity(CartItem item) {
    item.quantity -= 1;
    if (item.quantity == 0) {
      remove(item);
    }
    notifyListeners();
    saveCart(); // ✅ Save to Firestore
  }

  /// ✅ Clear cart (useful on logout)
  void clearCart() {
    _items.clear();
    notifyListeners();
    saveCart(); // ✅ Save to Firestore
  }

  /// ✅ Get total price of cart items
  // ignore: avoid_types_as_parameter_names
  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  /// ✅ Calculate tax
  double get tax => totalPrice * 0.05;

  /// ✅ Service fee
  double get serviceFee => 2.0;

  /// ✅ Get total amount including tax and service fee
  double get total => totalPrice + tax + serviceFee;

  /// ✅ Group items by shopId for checkout
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
