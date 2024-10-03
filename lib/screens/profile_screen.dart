import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _tastesController = TextEditingController();
  final TextEditingController _dietaryNeedsController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();

  bool _isEditing = false; // To toggle between view and edit mode
  String errorMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile on screen load
  }

  // Function to load user profile from Firestore
  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot profileSnapshot =
            await _firestore.collection('profiles').doc(user.uid).get();

        if (profileSnapshot.exists) {
          setState(() {
            Map<String, dynamic> userPreferences =
                profileSnapshot.data() as Map<String, dynamic>;
            // Populate text fields with existing data
            _nameController.text = userPreferences['name'] ?? '';
            _ageController.text = userPreferences['age']?.toString() ?? '';
            _sexController.text = userPreferences['sex'] ?? '';
            _tastesController.text =
                userPreferences['tastes']?.join(', ') ?? '';
            _dietaryNeedsController.text =
                userPreferences['dietary_needs']?.join(', ') ?? '';
            _cuisineController.text = userPreferences['cuisine'] ?? '';
            _preferencesController.text =
                userPreferences['preferences']?.join(', ') ?? '';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to load profile. Please try again.';
        });
      }
    }
  }

  // Function to save or update user preferences in Firestore
  Future<void> _saveProfile() async {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String sex = _sexController.text.trim();
    String tastes = _tastesController.text.trim();
    String dietaryNeeds = _dietaryNeedsController.text.trim();
    String cuisine = _cuisineController.text.trim();
    String preferences = _preferencesController.text.trim();
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('profiles').doc(user.uid).set({
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
        }, SetOptions(merge: true)); // Merges data to avoid overwriting

        setState(() {
          _isEditing = false; // Exit editing mode
          errorMessage = 'Profile updated successfully!';
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to update profile. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile(); // Save the profile when the check icon is pressed
              } else {
                setState(() {
                  _isEditing = true; // Enter edit mode
                });
              }
            },
          ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditing = false; // Exit edit mode without saving
                });
              },
            )
        ],
      ),
      body: Container(
        color: Colors.black, // Dark background color
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show loader while loading
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      keyboardType: TextInputType.number,
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _sexController,
                      decoration: InputDecoration(
                        labelText: 'Sex',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _tastesController,
                      decoration: InputDecoration(
                        labelText: 'Tastes (e.g., spicy, sweet)',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _dietaryNeedsController,
                      decoration: InputDecoration(
                        labelText: 'Dietary Needs (e.g., vegan, gluten-free)',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _cuisineController,
                      decoration: InputDecoration(
                        labelText: 'Preferred Cuisine (e.g., Indian)',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _preferencesController,
                      decoration: InputDecoration(
                        labelText:
                            'Preferences (e.g., weight-loss, post-surgery recovery)',
                        filled: true,
                        fillColor:
                            Colors.grey[800], // Dark background for text field
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                      ),
                      enabled: _isEditing, // Editable only in edit mode
                      style: TextStyle(color: Colors.white), // White text color
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
}









// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _tastesController = TextEditingController();
//   final TextEditingController _dietaryNeedsController = TextEditingController();
//   final TextEditingController _cuisineController = TextEditingController();
//   final TextEditingController _preferencesController = TextEditingController();

//   String errorMessage = '';
//   bool isLoading = true;

//   // Store user preferences fetched from Firestore
//   Map<String, dynamic> userPreferences = {};

//   Future<void> _saveProfile() async {
//     String tastes = _tastesController.text.trim();
//     String dietaryNeeds = _dietaryNeedsController.text.trim();
//     User? user = _auth.currentUser;

//     if (user != null) {
//       try {
//         // Save user preferences in Firestore
//         await _firestore.collection('profiles').doc(user.uid).set({
//           'tastes': tastes.split(',').map((taste) => taste.trim()).toList(),
//           'dietary_needs':
//               dietaryNeeds.split(',').map((need) => need.trim()).toList(),
//         });

//         setState(() {
//           errorMessage = 'Profile updated successfully!';
//         });
//       } catch (e) {
//         setState(() {
//           errorMessage = 'Failed to update profile. Please try again.';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Edit Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _tastesController,
//               decoration:
//                   InputDecoration(labelText: 'Tastes (e.g., spicy, sweet)'),
//             ),
//             TextField(
//               controller: _dietaryNeedsController,
//               decoration: InputDecoration(
//                   labelText: 'Dietary Needs (e.g., vegan, gluten-free)'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               child: Text('Save Profile'),
//             ),
//             if (errorMessage.isNotEmpty)
//               Text(
//                 errorMessage,
//                 style: TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
