import 'package:doorstepmart/firebase_options.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/landing.dart';
import 'package:doorstepmart/src/login/login.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/signup/signup.dart';
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => FavoriteModel()),
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

