import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _products = [];
  DocumentSnapshot? _lastDoc; // ✅ Keeps track of last document for pagination
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = true; // ✅ Indicates if there are more products to fetch
  static const int _limit = 10; // ✅ Controls how many products are loaded at once

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore; // ✅ Expose pagination status

  /// ✅ Fetch Products with Caching & Pagination
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_isLoading) return; // Prevents multiple fetch calls

    if (!forceRefresh && _products.isNotEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final fetchedProducts = await _productService.fetchProducts(limit: _limit);

      if (fetchedProducts.isEmpty) {
        _hasMore = false; // ✅ No more products to fetch
      }

      _products = fetchedProducts;
      _lastDoc = null; // ✅ Reset pagination for a fresh fetch
    } catch (e) {
      _hasError = true;
      print('❌ Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Fetch Next Page (Lazy Load)
  Future<void> fetchNextPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedProducts = await _productService.fetchProducts(lastDoc: _lastDoc, limit: _limit);

      if (fetchedProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(fetchedProducts);
        _lastDoc = fetchedProducts.last['id'] as DocumentSnapshot?;
      }
    } catch (e) {
      _hasError = true;
      print('❌ Error fetching more products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
