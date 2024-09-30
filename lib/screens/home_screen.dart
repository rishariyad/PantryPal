import 'package:flutter/material.dart';
import '/screens/pantry_screen.dart';
import '/screens/recipe_screen.dart';
import '/services/auth_service.dart';
import '/screens/login_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/saved_recipes_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Elevated buttons with uniform styling
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
                  MaterialPageRoute(builder: (context) => SavedRecipesScreen()),
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
      ),
      child: Text(text),
    );
  }
}
