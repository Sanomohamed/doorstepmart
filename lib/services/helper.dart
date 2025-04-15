import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserInFirestore(User user) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  final docSnapshot = await userDoc.get();
  if (!docSnapshot.exists) {
    // Create a user doc with default info
    await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? '',
      'photoURL': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('✅ Firestore user created: ${user.uid}');
    print("🔥 Saving user with display name: ${user.displayName}");
  } else {
    print('👀 Firestore user already exists');
  }
}
