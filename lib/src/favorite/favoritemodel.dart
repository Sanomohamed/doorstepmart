import 'package:flutter/material.dart';

class FavoriteItem {
  final String name;
  final String image;
  final double price;
  final String shopId; // ✅ Added shopId field

  FavoriteItem({
    required this.name,
    required this.image,
    required this.price,
    required this.shopId, // ✅ Ensure this is required
  });
}

class FavoriteModel extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => _favorites;

  void add(FavoriteItem item) {
    if (!_favorites.any((fav) => fav.name == item.name)) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void remove(String name) {
    _favorites.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  bool isFavorite(String name) {
    return _favorites.any((item) => item.name == name);
  }
}
