import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Enable Firestore Offline Persistence
  ProductService() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  /// ✅ Optimized Firestore Query
  Future<List<Map<String, dynamic>>> fetchProducts({DocumentSnapshot? lastDoc, int limit = 10}) async {
    try {
      print("🔍 Fetching products from Firestore...");

      Query query = _firestore.collection('products')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
        print("📌 Using pagination: fetching after document ID: ${lastDoc.id}");
      }

      final snapshot = await query.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.docs.isEmpty) {
        print("⚠️ No products found in Firestore.");
        return [];
      }

      print("✅ Firestore returned ${snapshot.docs.length} products.");

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        List<String> imageUrls = [];
        if (data.containsKey('imageUrls') && data['imageUrls'] is List) {
          imageUrls = List<String>.from(data['imageUrls']);
        }

        return {
          'id': doc.id,
          ...data,
          'imageUrls': imageUrls.isNotEmpty ? imageUrls : ["https://via.placeholder.com/150"],
          'documentSnapshot': doc, // ✅ Store snapshot for pagination
        };
      }).toList();

    } catch (e) {
      print("❌ Error fetching products: $e");
      throw Exception("❌ Error fetching products: $e");
    }
  }
}
