import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:taste_adda/view_models/recipes.dart';
import 'package:taste_adda/views/new_recipe.dart';
import 'package:taste_adda/views/recipe_details.dart';
import 'package:go_router/go_router.dart';
import 'package:taste_adda/views/recipes.dart';
import 'package:forui/forui.dart';

// import 'package:taste_adda/views/recipe_details.dart';

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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
          path: 'new-recipe',
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
    final theme = FThemes.zinc.dark; // Or your custom theme

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme.toApproximateMaterialTheme(),
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (_, child) => FTheme(data: theme, child: child!),
      routerConfig: _router,
    );
  }
}
