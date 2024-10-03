import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '/screens/pantry_screen.dart';
import '/screens/recipe_screen.dart';
import '/services/auth_service.dart';
import '/screens/login_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/saved_recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  List<String> _tips = [];
  String _currentTip = "";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadTips();
    startTipRotation();
  }

  // Load tips from a local JSON file (can be replaced with an API fetch)
  Future<void> loadTips() async {
    final String response = await rootBundle.loadString('assets/tips.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _tips = data.map((tip) => tip['tip'] as String).toList();
      _currentTip = _tips.isNotEmpty ? _tips[0] : "No tips available.";
    });
  }

  // Rotate tips every 5 seconds
  void startTipRotation() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _tips.length;
        _currentTip = _tips[_currentIndex];
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure to cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PantryPal Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut(); // Log out the user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen()), // Navigate to Login Screen
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen()), // Navigate to Profile Screen
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black, // Set background color to dark
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header for Tips Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.yellow, size: 28),
                  SizedBox(width: 10),
                  Text(
                    "Today's Zero Waste Tip",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Tip Display Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                color: Colors.blueGrey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  height: 100, // Fixed height for the tips section
                  child: Center(
                    child: Text(
                      _currentTip,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      overflow:
                          TextOverflow.ellipsis, // Ensure long tips are handled
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30), // Spacing before buttons

            // Buttons Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildElevatedButton(
                    context,
                    'Manage Pantry',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PantryScreen()),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildElevatedButton(
                    context,
                    'Generate Recipe',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeScreen()),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildElevatedButton(
                    context,
                    'Saved Recipes',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavedRecipesScreen()),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildElevatedButton(
                    context,
                    'Sign Out',
                    () async {
                      await _authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen()), // Navigate to Login Screen
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Extra space for better layout
          ],
        ),
      ),
    );
  }

  // Helper method to create styled elevated buttons
  Widget _buildElevatedButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[800], // Button color
        foregroundColor: Colors.white, // Text color
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle:
            TextStyle(fontSize: 18, fontWeight: FontWeight.w600), // Text style
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
      child: Text(text),
    );
  }
}
