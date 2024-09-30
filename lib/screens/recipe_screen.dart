//new-UI
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '/services/recipe_service.dart'; // Ensure your RecipeService is properly implemented

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  String? _generatedRecipe;
  bool _isLoading = false;

  Future<void> _generateRecipe() async {
    setState(() {
      _isLoading = true;
      _generatedRecipe = null;
    });

    List<String> ingredients = _ingredientsController.text
        .split(',')
        .map((ingredient) => ingredient.trim())
        .where((ingredient) =>
            ingredient.isNotEmpty) // Filter out empty ingredients
        .toList();

    if (ingredients.isNotEmpty) {
      try {
        String recipe = await RecipeService().generateRecipe(ingredients);
        setState(() {
          _generatedRecipe = recipe;
        });
      } catch (e) {
        print('Error generating recipe: $e');
        setState(() {
          _generatedRecipe = 'Failed to generate recipe';
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveRecipe() async {
    if (_generatedRecipe != null) {
      try {
        await RecipeService().saveRecipe(
          'Generated Recipe', // Modify this with an actual recipe name if available
          _ingredientsController.text
              .split(',')
              .map((ingredient) => ingredient.trim())
              .toList(),
          _generatedRecipe!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe saved successfully!')),
        );
      } catch (e) {
        print('Error saving recipe: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save recipe')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Recipe'),
      ),
      body: Container(
        color: Colors.black, // Dark background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field for ingredients
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (comma-separated)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[800], // Dark background for text field
                labelStyle: TextStyle(color: Colors.white), // White label text
              ),
              style: TextStyle(color: Colors.white), // White text color
            ),
            SizedBox(height: 20),

            // Generate Recipe Button
            ElevatedButton(
              onPressed: _isLoading ? null : _generateRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800], // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600), // Text style
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Generate Recipe'),
            ),

            // Display the generated recipe
            SizedBox(height: 20),
            if (_generatedRecipe != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _generatedRecipe!,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors
                                .white), // White text for generated recipe
                      ),
                      SizedBox(height: 20),
                      // Save Recipe Button
                      ElevatedButton(
                        onPressed: _saveRecipe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[800], // Button color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600), // Text style
                        ),
                        child: Text('Save Recipe'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/services/recipe_service.dart'; // Make sure your RecipeService is properly implemented

// class RecipeScreen extends StatefulWidget {
//   @override
//   _RecipeScreenState createState() => _RecipeScreenState();
// }

// class _RecipeScreenState extends State<RecipeScreen> {
//   final TextEditingController _ingredientsController = TextEditingController();
//   String? _generatedRecipe;
//   bool _isLoading = false;

//   Future<void> _generateRecipe() async {
//     setState(() {
//       _isLoading = true;
//       _generatedRecipe = null;
//     });

//     List<String> ingredients = _ingredientsController.text
//         .split(',')
//         .map((ingredient) => ingredient.trim())
//         .where((ingredient) =>
//             ingredient.isNotEmpty) // Filter out empty ingredients
//         .toList();

//     if (ingredients.isNotEmpty) {
//       try {
//         String recipe = await RecipeService().generateRecipe(ingredients);
//         setState(() {
//           _generatedRecipe = recipe;
//         });
//       } catch (e) {
//         print('Error generating recipe: $e');
//         setState(() {
//           _generatedRecipe = 'Failed to generate recipe';
//         });
//       }
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _saveRecipe() async {
//     if (_generatedRecipe != null) {
//       try {
//         await RecipeService().saveRecipe(
//           'Generated Recipe', // You can modify this with an actual recipe name if available
//           _ingredientsController.text
//               .split(',')
//               .map((ingredient) => ingredient.trim())
//               .toList(),
//           _generatedRecipe!,
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Recipe saved successfully!')),
//         );
//       } catch (e) {
//         print('Error saving recipe: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save recipe')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate Recipe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Input field for ingredients
//             TextField(
//               controller: _ingredientsController,
//               decoration: InputDecoration(
//                 labelText: 'Enter ingredients (comma-separated)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Generate Recipe Button
//             ElevatedButton(
//               onPressed: _isLoading ? null : _generateRecipe,
//               child: _isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text('Generate Recipe'),
//             ),

//             // Display the generated recipe
//             SizedBox(height: 20),
//             if (_generatedRecipe != null)
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         _generatedRecipe!,
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(height: 20),
//                       // Save Recipe Button
//                       ElevatedButton(
//                         onPressed: _saveRecipe,
//                         child: Text('Save Recipe'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/services/recipe_service.dart';

// class RecipeScreen extends StatefulWidget {
//   @override
//   _RecipeScreenState createState() => _RecipeScreenState();
// }

// class _RecipeScreenState extends State<RecipeScreen> {
//   final TextEditingController _ingredientsController = TextEditingController();
//   String? _generatedRecipe;
//   bool _isLoading = false;

//   Future<void> _generateRecipe() async {
//     setState(() {
//       _isLoading = true;
//       _generatedRecipe = null;
//     });

//     List<String> ingredients = _ingredientsController.text
//         .split(',')
//         .map((ingredient) => ingredient.trim())
//         //extra code line
//         .where((ingredient) =>
//             ingredient.isNotEmpty) // Filter out empty ingredients
//         .toList();

//     if (ingredients.isNotEmpty) {
//       try {
//         String recipe = await RecipeService().generateRecipe(ingredients);
//         setState(() {
//           _generatedRecipe = recipe;
//         });
//       } catch (e) {
//         print('Error generating recipe: $e');
//         setState(() {
//           _generatedRecipe = 'Failed to generate recipe';
//         });
//       }
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate Recipe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Input field for ingredients
//             TextField(
//               controller: _ingredientsController,
//               decoration: InputDecoration(
//                 labelText: 'Enter ingredients (comma-separated)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Generate Recipe Button
//             ElevatedButton(
//               onPressed: _isLoading ? null : _generateRecipe,
//               child: _isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text('Generate Recipe'),
//             ),

//             // Display the generated recipe
//             SizedBox(height: 20),
//             if (_generatedRecipe != null)
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Text(
//                     _generatedRecipe!,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
