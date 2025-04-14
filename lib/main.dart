import 'package:doorstepmart/src/order/purchase_history_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';    /// Importing necessary packages and files
import 'package:doorstepmart/firebase_options.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:doorstepmart/src/login/login.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/signup/signup.dart';

//initializes the Firebase app and sets up Firestore settings
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable Offline Mode for Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
 //creates the main app widget and sets up providers for state management, using MultiProvider to manage multiple providers in the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => FavoriteModel()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
/// The main app widget that sets up the MaterialApp and routes
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/PurchaseHistory': (context) => const PurchaseHistoryPage(),
        '/Signup': (context) => const Signup(),
        '/Landing': (context) => Landing(key: Landing.landingKey), 
        '/Login': (context) => const Login(),
      },
    );
  }
}
/// A widget that wraps the authentication logic and displays either, the landing page or the login page based on the authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return Landing(key: Landing.landingKey); // ✅ ensure this is consistent
        } else {
          return const Login();
        }
      },
    );
  }
}
