import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductService {
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      print("Internet connection: ${isConnected ? 'Online' : 'Offline'}");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get(GetOptions(source: isConnected ? Source.server : Source.cache));

      print("Fetched ${querySnapshot.docs.length} products from Firestore");

      return querySnapshot.docs.map((doc) {
        List<dynamic>? imageList = doc['imageUrls']; // Access imageUrls array
        String imageUrl = (imageList != null && imageList.isNotEmpty) ? imageList[0] : ''; // Get first image
        
        print("Product: ${doc['name']}, Image URL: $imageUrl"); // Debugging print

        return {
          'name': doc['name'],
          'price': doc['price'],
          'image': imageUrl, // Updated field to match Firestore structure
        };
      }).toList();
    } catch (error) {
      print("Error fetching Firestore products: $error");
      return [];
    }
  }
}
