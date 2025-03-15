import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      // ✅ Try fetching from cache first, fallback to Firestore if needed
      final snapshot = await _firestore
          .collection('products')
          .get(const GetOptions(source: Source.cache))
          .catchError((_) => _firestore.collection('products').get());

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}
