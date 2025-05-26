import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipes.dart';
// import 'package:taste_adda/views/new_recipe.dart';
import 'package:taste_adda/views/recipes.dart';
// import 'package:taste_adda/views/recipe_details.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipesViewModel()),
        // ChangeNotifierProvider(create: (_) => RecipeDetailsViewModel()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipesView(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF080808), // Background for all pages
        primaryColor: Color(0xFF080808), // Primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF080808),
        ),
      ),
      // initialRoute: '/',
      routes: {
        // '/': (context) => RecipesView(),
        // '/recipe': (context) => NewRecipePage(),
        // '/recipe-details': (context) => RecipeDetailsPage(),
      },
    );
  }
}
