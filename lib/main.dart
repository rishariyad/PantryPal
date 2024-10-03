import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  await Firebase.initializeApp(); // Initialize Firebase
  await setupRemoteConfig(); // Initialize Remote Config

  runApp(MyApp());
}

Future<void> setupRemoteConfig() async {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  // Set default values and fetch the latest config
  await remoteConfig.setDefaults(<String, dynamic>{
    'openai_api_key': 'default_api_key', // A default value (if needed)
  });

  await remoteConfig.fetchAndActivate(); // Fetches the latest config
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantryPal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            return AuthWrapper();
          }
          return SplashScreen();
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}
