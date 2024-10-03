# PantryPal

## Smart Recipe Generator for Zero Food Waste

PantryPal is an app designed to help users reduce food waste by providing personalized recipe suggestions and meal planning based on ingredients they already have. It also offers tips on sustainability and food waste reduction, while ensuring that users can enjoy a seamless experience, even offline.

Key Features:

- User Registration & Profile Management: Users can create an account, set dietary preferences, and manage their profile for consistent use across devices.
- Ingredient-Based Recipe Suggestions: Users can get recipe ideas based on what’s available in their pantry, with filters for specific diets or cuisines.
- AI-Powered Recipe Generation: The app creates unique recipes using available ingredients, allowing for creativity and reducing food waste.
- Meal Planning: A weekly meal planner helps users schedule meals and automatically suggests recipes based on their pantry.
- Recipe Personalization: The app suggests ingredient substitutions and allows portion adjustments for custom recipes.
- Social Sharing: Users can share their favorite recipes with others and explore community-generated recipes.
- Zero Waste Tips & Insights: The app provides tips on reducing food waste and tracks the user's impact on sustainability over time.

### Setup Firebase Configuration

Before running the project, you must configure Firebase for your own project:

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/).
2. **Add Firebase to your Flutter app**:
   - Download the `google-services.json` file for Android and place it in `android/app/`.
   - Download the `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`.
   - Follow the Firebase setup steps to generate the `firebase_options.dart` file using the `flutterfire` CLI.
3. **Set up Firebase Remote Config**:
   - In Firebase Console, go to **Remote Config** and add a parameter `openai_api_key` with your own OpenAI API key.
