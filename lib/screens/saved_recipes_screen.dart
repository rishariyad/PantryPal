// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SavedRecipesScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saved Recipes'),
//       ),
//       body: user != null
//           ? StreamBuilder(
//               stream: _firestore
//                   .collection('recipes')
//                   .doc(user.uid)
//                   .collection('userRecipes')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('No saved recipes.'));
//                 }

//                 return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     var recipe = snapshot.data!.docs[index];

//                     return ListTile(
//                       title: Text(recipe['recipe_name']),
//                       subtitle: Text(
//                           'Ingredients: ${recipe['ingredients'].join(", ")}'),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => _deleteRecipe(recipe.id),
//                       ),
//                       onTap: () {
//                         // Navigate to recipe details screen if needed
//                         _showRecipeDetails(context, recipe);
//                       },
//                     );
//                   },
//                 );
//               },
//             )
//           : Center(child: Text('Please log in to see your saved recipes.')),
//     );
//   }

//   // Function to delete a recipe
//   Future<void> _deleteRecipe(String recipeId) async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       await _firestore
//           .collection('recipes')
//           .doc(user.uid)
//           .collection('userRecipes')
//           .doc(recipeId)
//           .delete();
//     }
//   }

//   // Function to show detailed recipe view (optional)
//   void _showRecipeDetails(BuildContext context, DocumentSnapshot recipe) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(recipe['recipe_name']),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Ingredients: ${recipe['ingredients'].join(", ")}'),
//               SizedBox(height: 10),
//               Text('Instructions: ${recipe['instructions']}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//new-UI
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedRecipesScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: Container(
        color: Colors.black, // Dark background color
        child: user != null
            ? StreamBuilder(
                stream: _firestore
                    .collection('recipes')
                    .doc(user.uid)
                    .collection('userRecipes')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text('No saved recipes.',
                            style: TextStyle(color: Colors.white)));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var recipe = snapshot.data!.docs[index];

                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        color: Colors.grey[850], // Dark card background
                        child: ListTile(
                          title: Text(recipe['recipe_name'],
                              style: TextStyle(
                                  color: Colors.white)), // White text color
                          subtitle: Text(
                              'Ingredients: ${recipe['ingredients'].join(", ")}',
                              style: TextStyle(
                                  color: Colors
                                      .white)), // Lighter text color for ingredients
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red), // Red delete icon
                            onPressed: () => _deleteRecipe(recipe.id, context),
                          ),
                          onTap: () {
                            // Navigate to recipe details screen if needed
                            _showRecipeDetails(context, recipe);
                          },
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'Please log in to see your saved recipes.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  // Function to delete a recipe
  Future<void> _deleteRecipe(String recipeId, BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('recipes')
          .doc(user.uid)
          .collection('userRecipes')
          .doc(recipeId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted successfully!')),
      );
    }
  }

  // Function to show detailed recipe view (optional)
  void _showRecipeDetails(BuildContext context, DocumentSnapshot recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(recipe['recipe_name'],
              style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ingredients: ${recipe['ingredients'].join(", ")}',
                  style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              Text('Instructions: ${recipe['instructions']}',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
