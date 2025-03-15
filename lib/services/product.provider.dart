import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_isLoading) return; // ✅ Prevents re-fetching while already loading

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // ✅ Ensure Firestore is not returning null
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get(const GetOptions(source: Source.cache))
          .catchError((_) => FirebaseFirestore.instance.collection('products').get());

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No products found");
      }

      _products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; // ✅ Ensure valid data
        if (data == null) return <String, dynamic>{}; // Prevent null crashes
        return data;
      }).toList();

      if (_products.isEmpty) {
        throw Exception("No products found in Firestore.");
      }
    } catch (e) {
      _hasError = true;
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshProducts() async {
    await fetchProducts(forceRefresh: true);
  }
}
