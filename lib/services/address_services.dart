import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressService {
  final _firestore = FirebaseFirestore.instance;
  final _userId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> get addressStream {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteAddress(String docId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .doc(docId)
        .delete();
  }

  Future<void> setAsDefault(String selectedId) async {
    final batch = _firestore.batch();
    final addresses = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .get();

    for (var doc in addresses.docs) {
      batch.update(doc.reference, {
        'isDefault': doc.id == selectedId,
      });
    }

    await batch.commit();
  }
}
