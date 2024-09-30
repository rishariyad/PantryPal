import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database
// import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Example using dotenv package

class RecipeService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ??
      'No API Key Found'; // Use environment variables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> generateRecipe(List<String> ingredients) async {
    User? user = _auth.currentUser;

    // Load user profile from Firestore
    DocumentSnapshot profileSnapshot =
        await _firestore.collection('profiles').doc(user?.uid).get();

    // Get user's preferences (tastes and dietary needs)
    List<String> tastes = [];
    List<String> dietaryNeeds = [];
    String cuisine = '';
    List<String> preferences = [];

    if (profileSnapshot.exists) {
      tastes = List<String>.from(profileSnapshot['tastes']);
      dietaryNeeds = List<String>.from(profileSnapshot['dietary_needs']);
      cuisine = profileSnapshot['cuisine'] ?? '';
      preferences = List<String>.from(profileSnapshot['preferences']);
    }

    // Create a personalized prompt including user's preferences
    String personalizedPrompt =
        'Suggest a recipe with the following ingredients: ${ingredients.join(", ")}';
    if (tastes.isNotEmpty) {
      personalizedPrompt +=
          '. It should match these taste preferences: ${tastes.join(", ")}.';
    }
    if (dietaryNeeds.isNotEmpty) {
      personalizedPrompt +=
          ' Also, consider these dietary needs: ${dietaryNeeds.join(", ")}.';
    }
    if (cuisine.isNotEmpty) {
      personalizedPrompt += ' The recipe should be for $cuisine cuisine.';
    }
    if (preferences.isNotEmpty) {
      personalizedPrompt +=
          ' Keep in mind the following preferences: ${preferences.join(", ")}.';
    }

    int retries = 1;
    while (retries > 0) {
      try {
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo', // Use the correct model
            'messages': [
              {
                'role': 'system',
                'content':
                    // 'You are a helpful assistant that suggests recipes based on ingredients.'
                    'You are a helpful assistant that suggests personalized recipes based on ingredients, tastes, and dietary needs.'
              },
              {
                'role': 'user',
                // 'content':
                //     'Suggest a recipe with the following ingredients: ${ingredients.join(", ")}'
                'content': personalizedPrompt
              }
            ],
            'max_tokens': 200,
          }),
        );

        if (response.statusCode == 200) {
          // final data = jsonDecode(response.body);
          // return data['choices'][0]['text'].trim();

          final data = jsonDecode(response.body);
          final recipe = data['choices'][0]['message']['content'];
          if (recipe != null) {
            return recipe.trim(); // Only trim if recipe is not null
          } else {
            throw Exception('Failed to generate recipe: No content returned');
          }
        } else {
          print('Error: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception('Failed to generate recipe');
        }
      } catch (e) {
        print('Error generating recipe: $e');
      }
      retries--;
      await Future.delayed(Duration(seconds: 1)); // Wait before retrying
    }
    throw Exception('Failed to generate recipe after retries');
  }

  // Save recipe to Firestore
  Future<void> saveRecipe(
      String recipeName, List<String> ingredients, String instructions) async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('recipes')
          .doc(user.uid)
          .collection('userRecipes')
          .add({
        'recipe_name': recipeName,
        'ingredients': ingredients,
        'instructions': instructions,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
