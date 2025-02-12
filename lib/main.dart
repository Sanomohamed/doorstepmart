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
  await _requestLocationPermission();
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

Future<Position?> _requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, request the user to enable them
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try requesting permissions again
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can get the location
  await Geolocator.getCurrentPosition();
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
          return Landing(position: position); // Replace with your home screen
        } else {
          return Login(); // Replace with your login form
        }
      },
    );
  }
}

