import 'package:doorstepmart/services/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> registerWithEmailPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    await userCredential.user!.updateDisplayName(name);
    await userCredential.user!.reload(); // Refresh the user object
    final updatedUser = _auth.currentUser!;
    await createUserInFirestore(updatedUser); 

      await createUserInFirestore(userCredential.user!);
      return userCredential;
      // User registered successfully
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
      }
    } catch (e) {
      print('An unknown error occurred: $e');
    }
    return null;
  }

  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
      // User signed in successfully
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
      }
    } catch (e) {
      print('An unknown error occurred: $e');
    }
     return null; 
  }


  Future<UserCredential?> signInWithGoogle() async {
  try {
      print('Attempting to sign in with Google');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in aborted by user');
        return null;
      }
      print('Google sign-in successful: ${googleUser.email}');
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
       await createUserInFirestore(userCredential.user!);
      print('User signed in with Google successfully: ${userCredential.user?.uid}');
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      print('An unknown error occurred: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    // Implement your sign-out logic here
     try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
