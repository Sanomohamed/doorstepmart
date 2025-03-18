import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Fetch Products (Server First, Fixes Cache Issues)
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

      // ✅ Always fetch from Firestore server (avoid cache inconsistencies)
      final snapshot = await query.get(const GetOptions(source: Source.server));

      if (snapshot.docs.isEmpty) {
        print("⚠️ No products found in Firestore.");
        return [];
      }

      print("✅ Firestore returned ${snapshot.docs.length} products.");

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // ✅ Ensure imageUrls is a valid list
        List<String> imageUrls = [];
        if (data.containsKey('imageUrls') && data['imageUrls'] is List) {
          imageUrls = List<String>.from(data['imageUrls']);
        }

        return {
          'id': doc.id,
          ...data,
          'imageUrls': imageUrls.isNotEmpty ? imageUrls : ["https://via.placeholder.com/150"], // ✅ Placeholder for missing images
        };
      }).toList();

    } catch (e) {
      print("❌ Error fetching products: $e");
      throw Exception("❌ Error fetching products: $e");
    }
  }
}
