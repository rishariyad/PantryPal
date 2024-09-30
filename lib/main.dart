import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Example using dotenv package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: firebaseOptions,
      // options: firebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  // await dotenv.load(fileName: ".env"); // Load the .env file
  // Initialize Firebase
  await loadEnv(); // Load the environment variables
  runApp(MyApp());
}

Future<void> loadEnv() async {
  if (kIsWeb) {
    // For web: Manually load environment variables (but not hardcoded)
    dotenv
        .testLoad(); // You will handle the API key through a web service later
  } else {
    // For mobile: Load environment variables from .env file
    await dotenv.load(fileName: ".env");
  }
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
      // home: SplashScreen(),
      // home: AuthWrapper(), // Initial screen after authentication
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // Show the splash screen while loading
          }
          // If user is signed in, show the AuthWrapper (or HomeScreen)
          if (snapshot.hasData) {
            return AuthWrapper(); // Change to your actual HomeScreen if needed
          }
          // If user is not signed in, show the splash screen or login screen
          return SplashScreen();
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the user is currently logged in
    User? user = FirebaseAuth.instance.currentUser;

    // If the user is logged in, show HomeScreen, otherwise show LoginScreen
    if (user == null) {
      return LoginScreen(); // Show login if not authenticated
    } else {
      return HomeScreen(); // Show home if authenticated
    }
  }
}
