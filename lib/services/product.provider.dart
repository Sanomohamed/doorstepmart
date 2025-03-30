import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _products = [];
  DocumentSnapshot? _lastDoc;
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = true;
  bool _isFetchedOnce = false; // neEnsures fetch only happens once
  static const int _limit = 10;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;

  //Fetch Products (Only Fetch if Necessary)
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    print("🔍 fetchProducts() called...");

    if (_isLoading) {
      print("⚠️ Already loading products. Skipping fetch.");
      return;
    }

    if (!forceRefresh && _isFetchedOnce) {
      print("✅ Using cached products. No need to refetch.");
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
      _products = fetchedProducts;

      if (fetchedProducts.isNotEmpty) {
        _lastDoc = fetchedProducts.last['documentSnapshot'] as DocumentSnapshot;
      } else {
        _lastDoc = null;
      }

      _isFetchedOnce = true; // Mark as fetched once

    } catch (e) {
      _hasError = true;
      print('❌ Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Fetch Next Page (Pagination)
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
        _products.addAll(fetchedProducts);

        if (fetchedProducts.isNotEmpty) {
          _lastDoc = fetchedProducts.last['documentSnapshot'] as DocumentSnapshot;
        }
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
