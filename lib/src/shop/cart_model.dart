import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// CartItem remains unchanged
class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;
  final String shopId;
  String shopName;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.shopId,
    required this.shopName,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
        'shopId': shopId,
        'shopName': shopName,
      };

  factory CartItem.fromMap(Map<String, dynamic> data) => CartItem(
        name: data['name'],
        image: data['image'],
        price: (data['price'] as num).toDouble(),
        quantity: data['quantity'],
        shopId: data['shopId'],
        shopName: data['shopName'] ?? "Unknown Shop",
      );
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final Map<String, String> _shopNamesCache = {};

  // ← NEW: hold the selected address for delivery
  Map<String, dynamic>? _selectedAddress;
  Map<String, dynamic>? get selectedAddress => _selectedAddress;

  /// Update the chosen delivery address once—and it will persist
  void setSelectedAddress(Map<String, dynamic> address) {
    _selectedAddress = address;
    notifyListeners();
  }

  List<CartItem> get items => _items;

  DocumentReference<Map<String, dynamic>> get cartRef {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance.collection('carts').doc(user.uid);
  }

  Future<void> fetchCart() async {
    try {
      final cartDoc = await cartRef.get();
      if (cartDoc.exists) {
        final cartData = cartDoc.data();
        if (cartData != null && cartData.containsKey('items')) {
          _items
            ..clear()
            ..addAll((cartData['items'] as List<dynamic>)
                .map((item) => CartItem.fromMap(item)));
          await _fetchShopNames();
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("🔥 Error fetching cart: $e");
    }
  }

   /// Call this at startup to load the user’s default delivery address.
  Future<void> loadDefaultAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) {
      final addr = snap.docs.first.data() as Map<String, dynamic>;
      _selectedAddress = addr;
      notifyListeners();
    }
  }

  Future<void> _fetchShopNames() async {
    for (var item in _items) {
      if (!_shopNamesCache.containsKey(item.shopId)) {
        final shopName = await _fetchShopName(item.shopId);
        _shopNamesCache[item.shopId] = shopName;
        item.shopName = shopName;
      }
    }
    notifyListeners();
  }

  Future<String> _fetchShopName(String shopId) async {
    if (_shopNamesCache.containsKey(shopId)) {
      return _shopNamesCache[shopId]!;
    }
    try {
      final shopDoc = await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .get();
      if (shopDoc.exists) {
        final name = shopDoc['name'] ?? "Unknown Shop";
        _shopNamesCache[shopId] = name;
        return name;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }
    return "Unknown Shop";
  }

  Future<void> saveCart() async {
    try {
      await cartRef.set({
        'items': _items.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      debugPrint("🔥 Error saving cart: $e");
    }
  }

  void add(CartItem item) async {
    final name = await _fetchShopName(item.shopId);
    item.shopName = name;

    for (var cartItem in _items) {
      if (cartItem.name == item.name && cartItem.shopId == item.shopId) {
        cartItem.quantity += 1;
        notifyListeners();
        saveCart();
        return;
      }
    }
    _items.add(item);
    notifyListeners();
    saveCart();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
    saveCart();
  }

  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
    saveCart();
  }

  void decreaseQuantity(CartItem item) {
    item.quantity -= 1;
    if (item.quantity <= 0) remove(item);
    notifyListeners();
    saveCart();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    saveCart();
  }

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  double get tax => totalPrice * 0.05;

  double get serviceFee => 2.0;

  double get total => totalPrice + tax + serviceFee;

  Map<String, List<CartItem>> getGroupedByShop() {
    final Map<String, List<CartItem>> grouped = {};
    for (var item in _items) {
      grouped.putIfAbsent(item.shopName, () => []).add(item);
    }
    return grouped;
  }
}
