import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;
  final String shopId; // ✅ Keep shopId for database reference
  String shopName; // ✅ Store shop name for display

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.shopId,
    required this.shopName, // ✅ Store shop name
  });

  /// ✅ Convert CartItem to Firestore-friendly format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'shopId': shopId,
      'shopName': shopName, // ✅ Ensure shop name is stored
    };
  }

  /// ✅ Create CartItem from Firestore document
  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      name: data['name'],
      image: data['image'],
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'],
      shopId: data['shopId'],
      shopName: data['shopName'] ?? "Unknown Shop", // ✅ Fetch stored shop name
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final Map<String, String> _shopNamesCache = {}; // ✅ Cache shop names

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
          await _fetchShopNames(); // ✅ Ensure shop names are up-to-date
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("🔥 Error fetching cart: $e");
    }
  }

  /// ✅ Fetch shop names for all cart items
  Future<void> _fetchShopNames() async {
    for (var item in _items) {
      if (!_shopNamesCache.containsKey(item.shopId)) {
        String shopName = await _fetchShopName(item.shopId);
        _shopNamesCache[item.shopId] = shopName;
        item.shopName = shopName;
      }
    }
    notifyListeners();
  }

  /// ✅ Fetch shop name from Firestore
  Future<String> _fetchShopName(String shopId) async {
    if (_shopNamesCache.containsKey(shopId)) {
      return _shopNamesCache[shopId]!;
    }

    try {
      DocumentSnapshot shopDoc =
          await FirebaseFirestore.instance.collection('shops').doc(shopId).get();

      if (shopDoc.exists) {
        String shopName = shopDoc['name'] ?? "Unknown Shop";
        _shopNamesCache[shopId] = shopName;
        return shopName;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }

    return "Unknown Shop";
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
void add(CartItem item) async {
  String shopName = await _fetchShopName(item.shopId); // ✅ Fetch correct shop name
  item.shopName = shopName;

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

  /// ✅ Remove item from cart
  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
    saveCart();
  }

  /// ✅ Increase item quantity
  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
    saveCart();
  }

  /// ✅ Decrease item quantity
  void decreaseQuantity(CartItem item) {
    item.quantity -= 1;
    if (item.quantity == 0) {
      remove(item);
    }
    notifyListeners();
    saveCart();
  }

  /// ✅ Clear cart (useful on logout)
  void clearCart() {
    _items.clear();
    notifyListeners();
    saveCart();
  }

  /// ✅ Get total price of cart items
  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  /// ✅ Calculate tax
  double get tax => totalPrice * 0.05;

  /// ✅ Service fee
  double get serviceFee => 2.0;

  /// ✅ Get total amount including tax and service fee
  double get total => totalPrice + tax + serviceFee;

  /// ✅ Group items by shopName for checkout
  Map<String, List<CartItem>> getGroupedByShop() {
    Map<String, List<CartItem>> groupedItems = {};
    for (var item in _items) {
      if (!groupedItems.containsKey(item.shopName)) {
        groupedItems[item.shopName] = [];
      }
      groupedItems[item.shopName]!.add(item);
    }
    return groupedItems;
  }
}
