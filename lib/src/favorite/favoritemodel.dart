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

  void add(FavoriteItem item) {
    _favorites.add(item);
    notifyListeners();
  }
}