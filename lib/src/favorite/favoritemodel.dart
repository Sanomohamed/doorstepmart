import 'package:flutter/material.dart';

class FavoriteItem {
  final String name;
  final String image;
  final double price;

  FavoriteItem({required this.name, required this.image, required this.price});
}

class FavoriteModel extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => _favorites;

  // ✅ Add to favorites
  void add(FavoriteItem item) {
    _favorites.add(item);
    notifyListeners();
  }

  // ✅ Remove from favorites
  void remove(String name) {
    _favorites.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  // ✅ Check if item is in favorites
  bool isFavorite(String name) {
    return _favorites.any((item) => item.name == name);
  }
}