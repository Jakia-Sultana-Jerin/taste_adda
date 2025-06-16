import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:taste_adda/view_models/recipes.dart';
import 'package:taste_adda/view_models/review.dart';
import 'package:taste_adda/view_models/user_view_model.dart';
import 'package:taste_adda/views/general.dart';
import 'package:taste_adda/views/new_recipe.dart';
import 'package:taste_adda/views/profile.dart';

import 'package:taste_adda/views/recipe_details.dart';
import 'package:go_router/go_router.dart';


import 'package:taste_adda/views/recipes.dart';
import 'package:forui/forui.dart';

// import 'package:taste_adda/views/recipe_details.dart';

import 'package:flutter/services.dart';
import 'package:taste_adda/views/setting.dart';
import 'package:taste_adda/views/user_profile.dart';






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
         ChangeNotifierProvider(create: (_) => UserViewModel()),
          ChangeNotifierProvider(create: (_) => ReviewViewModel()),
      ],
      child: MainApp(),
    ),
  );


   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize("e34d9844-204c-4a8a-a8ef-7e064f326d73");
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(false);
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
          GoRoute(
          path: 'userprofile',
          builder: (BuildContext context, GoRouterState state) {
            return  UserProfile();
          },
        ),

        //  GoRoute(
        //   path: 'recipe-setting',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return RecipeSetting  ();
        //   },
        // ),

           GoRoute(
          path: 'general-setting',
          builder: (BuildContext context, GoRouterState state) {
            return generalPage  ();
          },
        ),
           GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) {
            return SettingPage ();
          },
        ),

             GoRoute(
          path: 'profile-setting',
          builder: (BuildContext context, GoRouterState state) {
            return ProfilePage  ();
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
