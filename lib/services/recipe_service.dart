import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RecipeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Method to get the API key from Firebase Remote Config
  String get apiKey {
    return _remoteConfig.getString('openai_api_key');
  }

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
            'Authorization': 'Bearer $apiKey', // Use the proper API key
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {
                'role': 'system',
                'content':
                    'You are a helpful assistant that suggests personalized recipes based on ingredients, tastes, and dietary needs.'
              },
              {
                'role': 'user',
                'content': personalizedPrompt,
              }
            ],
            'max_tokens': 200,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final recipe = data['choices'][0]['message']['content'];
          if (recipe != null) {
            return recipe.trim();
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
