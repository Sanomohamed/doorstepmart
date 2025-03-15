import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/firebase_options.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:doorstepmart/src/login/login.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/signup/signup.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
   await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('a667739859177bcbe907cd88dd77f817cbc3e12b'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

   // Enable offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Allows offline mode
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // No cache size limit
  );
  
 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => FavoriteModel()),
        ChangeNotifierProvider(create: (context) => ProductProvider()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Position? position;
  const MyApp({super.key,this.position});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(),
       routes: {
        '/Signup': (context) => Signup(),
        '/Landing': (context) => Landing(),
        '/Login': (context) => Login(),
        
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final Position? position;
  const AuthWrapper({super.key,this.position});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Landing(); // Replace with your home screen
        } else {
          return Login(); // Replace with your login form
        }
      },
    );
  }
}

