import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteItem {
  final String name;
  final String image;
  final double price;
  final String shopId;
  final String shopName;

  FavoriteItem({
    required this.name,
    required this.image,
    required this.price,
    required this.shopId,
    required this.shopName,
  });

  /// ✅ Convert to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'shopId': shopId,
      'shopName': shopName,
    };
  }

  /// ✅ Create from Firestore document
  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      shopId: map['shopId'] ?? '',
      shopName: map['shopName'] ?? '',
    );
  }
}

class FavoriteModel extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<FavoriteItem> get favorites => _favorites;

  String? get userId => _auth.currentUser?.uid;

  /// ✅ Fetch favorites from Firestore
  Future<void> loadFavorites() async {
    if (userId == null) return;
    try {
      final snapshot = await _firestore.collection('favorites').doc(userId).collection('items').get();
      _favorites.clear();
      for (var doc in snapshot.docs) {
        _favorites.add(FavoriteItem.fromMap(doc.data()));
      }
      notifyListeners();
    } catch (e) {
      debugPrint("🔥 Error loading favorites: $e");
    }
  }

  /// ✅ Add favorite & save to Firestore
  Future<void> add(FavoriteItem item) async {
    if (_favorites.any((fav) => fav.name == item.name && fav.shopId == item.shopId)) return;
    _favorites.add(item);
    notifyListeners();

    if (userId == null) return;
    try {
      await _firestore.collection('favorites').doc(userId).collection('items').doc(item.name).set(item.toMap());
    } catch (e) {
      debugPrint("🔥 Error adding favorite: $e");
    }
  }

  /// ✅ Remove favorite & delete from Firestore
  Future<void> remove(String name) async {
    _favorites.removeWhere((item) => item.name == name);
    notifyListeners();

    if (userId == null) return;
    try {
      await _firestore.collection('favorites').doc(userId).collection('items').doc(name).delete();
    } catch (e) {
      debugPrint("🔥 Error removing favorite: $e");
    }
  }

  bool isFavorite(String name) {
    return _favorites.any((item) => item.name == name);
  }
}
