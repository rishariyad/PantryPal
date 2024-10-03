import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart'; // Import the screen you want to navigate to after signup

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _tastesController = TextEditingController();
  final TextEditingController _dietaryNeedsController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorMessage = '';

  Future<void> _signup() async {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String sex = _sexController.text.trim();
    String tastes = _tastesController.text.trim();
    String dietaryNeeds = _dietaryNeedsController.text.trim();
    String cuisine = _cuisineController.text.trim();
    String preferences = _preferencesController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        sex.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      try {
        // Create a new user
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save additional user data to Firestore
        await _firestore
            .collection('profiles')
            .doc(userCredential.user?.uid)
            .set({
          'name': name,
          'age': age,
          'sex': sex,
          'tastes': tastes.split(',').map((taste) => taste.trim()).toList(),
          'dietary_needs':
              dietaryNeeds.split(',').map((need) => need.trim()).toList(),
          'cuisine': cuisine,
          'preferences': preferences
              .split(',')
              .map((preference) => preference.trim())
              .toList(),
        });

        // Navigate to Login or another screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen()), // Navigate to Login Screen
        );
      } catch (e) {
        setState(() {
          errorMessage = 'Signup failed. Please try again.';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Container(
        color: Colors.black, // Dark background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(_nameController, 'Name'),
              SizedBox(height: 10),
              _buildTextField(_ageController, 'Age',
                  keyboardType: TextInputType.number),
              SizedBox(height: 10),
              _buildTextField(_sexController, 'Sex'),
              SizedBox(height: 10),
              _buildTextField(_tastesController, 'Tastes (e.g., spicy, sweet)'),
              SizedBox(height: 10),
              _buildTextField(_dietaryNeedsController,
                  'Dietary Needs (e.g., vegan, gluten-free)'),
              SizedBox(height: 10),
              _buildTextField(
                  _cuisineController, 'Preferred Cuisine (e.g., Indian)'),
              SizedBox(height: 10),
              _buildTextField(_preferencesController,
                  'Preferences (e.g., weight-loss, post-surgery recovery)'),
              SizedBox(height: 10),
              _buildTextField(_emailController, 'Email'),
              SizedBox(height: 10),
              _buildTextField(_passwordController, 'Password',
                  obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[800], // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600), // Text style
                ),
                child: Text('Sign Up'),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create styled text fields
  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[800], // Dark background for text field
        labelStyle: TextStyle(color: Colors.white), // White label text
      ),
      obscureText: obscureText,
      style: TextStyle(color: Colors.white), // White text color
      keyboardType: keyboardType,
    );
  }
}
