import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Fetch Products with Pagination & Caching
  Future<List<Map<String, dynamic>>> fetchProducts({DocumentSnapshot? lastDoc, int limit = 10}) async {
    try {
      Query query = _firestore.collection('products').orderBy('timestamp', descending: true).limit(limit);

      // ✅ Use last fetched document for pagination
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      // ✅ Fetch from cache first, then fallback to Firestore
      final snapshot = await query
          .get(const GetOptions(source: Source.cache))
          .catchError((_) => query.get());

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>, // ✅ Ensure valid data structure
      }).toList();
    } catch (e) {
      throw Exception("❌ Error fetching products: $e");
    }
  }
}
