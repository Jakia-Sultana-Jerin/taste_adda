import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:taste_adda/view_models/recipes.dart';
import 'package:taste_adda/views/new_recipe.dart';
import 'package:taste_adda/views/recipe_details.dart';
import 'package:go_router/go_router.dart';
import 'package:taste_adda/views/recipes.dart';
// import 'package:taste_adda/views/recipe_details.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipesViewModel()),
        ChangeNotifierProvider(create: (_) => RecipeViewModel()),
      ],
      child: MainApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const RecipesView();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'recipe',
          builder: (BuildContext context, GoRouterState state) {
            final recipeId = state.uri.queryParameters['id'];

            if (recipeId == null) {
              return const Scaffold(
                body: Center(child: Text("No recipe ID provided")),
              );
            }
            return RecipeDetailsPage(id: recipeId);
          },
        ),
        GoRoute(
          path: 'new',
          builder: (BuildContext context, GoRouterState state) {
            return const NewRecipePage();
          },
        ),
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // home: RecipesView(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF080808), // Background for all pages
        primaryColor: Color(0xFF080808), // Primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF080808),
        ),
      ),
      routerConfig: _router,
    );
  }
}
