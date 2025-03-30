import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchShopName(String shopId) async {
  try {
    DocumentSnapshot shopDoc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
    if (shopDoc.exists) {
      var shopData = shopDoc.data() as Map<String, dynamic>?;
      return shopData?['shopName'] ?? "Unknown Shop";
    }
  } catch (e) {
    return "Unknown Shop";
  }
  return "Unknown Shop";
}
