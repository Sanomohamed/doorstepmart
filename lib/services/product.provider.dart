import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _products = [];
  DocumentSnapshot? _lastDoc; // ✅ Track last document for pagination
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = true; // ✅ Indicates if there are more products to fetch
  static const int _limit = 10; // ✅ Controls batch size of products loaded

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;

  /// ✅ Fetch Products (Server First, Fixes Cache Issues)
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    print("🔍 fetchProducts() was called...");

    if (_isLoading) {
      print("⚠️ Already loading products. Skipping fetch.");
      return;
    }

    if (!forceRefresh && _products.isNotEmpty) {
      print("✅ Using cached products. Skipping fetch.");
      notifyListeners();
      return;
    }

    print("⏳ Fetching products from Firestore...");
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final fetchedProducts = await _productService.fetchProducts(limit: _limit);

      if (fetchedProducts.isEmpty) {
        print("⚠️ No products found in Firestore.");
        _hasMore = false;
      } else {
        print("✅ Loaded ${fetchedProducts.length} products.");
      }

      _products.clear(); // ✅ Prevent duplicates
      _products.addAll(fetchedProducts);
      _lastDoc = null; // ✅ Reset pagination

    } catch (e) {
      _hasError = true;
      print('❌ Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Fetch Next Page (Pagination)
  Future<void> fetchNextPage() async {
    if (_isLoading || !_hasMore) return;

    print("🔄 Fetching next page of products...");
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedProducts = await _productService.fetchProducts(lastDoc: _lastDoc, limit: _limit);

      if (fetchedProducts.isEmpty) {
        print("⚠️ No more products available.");
        _hasMore = false;
      } else {
        print("✅ Loaded ${fetchedProducts.length} more products.");
        
        // ✅ Append new products instead of overwriting
        _products.addAll(fetchedProducts);
        _lastDoc = fetchedProducts.isNotEmpty ? fetchedProducts.last['id'] as DocumentSnapshot? : null;
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
