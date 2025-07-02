import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/recipe_model.dart';
import 'package:taste_adda/view_models/sign_in_view_model.dart';

class RecipesViewModel extends ChangeNotifier {
  late final Dio _dio;
  final baseUrl = kIsWeb ? 'https://dingo-proper-mistakenly.ngrok-free.app/' : 'https://dingo-proper-mistakenly.ngrok-free.app/';

  List<RecipeModel> _recipes = [];
  Future<void>? _recipesFuture;
   
  RecipesViewModel() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
  }

  List<RecipeModel> get recipes => _recipes;
  Future<void> get recipesFuture => _recipesFuture ??= fetchRecipes();

  Future<void> fetchRecipes() async {
    try {
      final response = await _dio.get("/recipes");

      print('Number of recipes received: ${response.data['data'].length}');
      print("STATUS: ${response.statusCode}");
      print("BODY  : ${response.data}");

      if (response.statusCode == 200 && response.data['error'] == false) {
        final List<dynamic> dataList = response.data['data'];

        // map each json into RecipeModel instance
        _recipes =
            dataList
                .map(
                  (json) => RecipeModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();

        notifyListeners();
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  //post

  Future<RecipeModel?> addRecipe(
  String title,
  String description,
  String thumbUrl,
  List<String> steps,
  Map<String, dynamic> ingredients,
  String category,
  SignInViewModel signInViewModel,

) async {
  final body = {
    'title': title,
    'description': description,
    'thumbUrl': thumbUrl,
    'steps': steps,
    'ingredients': ingredients,
    'category': category,
  };

  debugPrint('🔼 Sending: $body');

  try {
    final response = await _dio.post(
      '/recipes',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${signInViewModel.idToken}',
        },
      ),
    );

    debugPrint("Actual ID token sent: ${signInViewModel.idToken}");

    debugPrint('🔽 Response: ${response.statusCode} ${response.data}');

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data['error'] == false &&
        response.data['data'] != null) {
      
      final dynamic data = response.data['data'];

      if (data is Map<String, dynamic>) {
        final recipe = RecipeModel.fromJson(data);
        _recipes.add(recipe);
        notifyListeners();
        print('✅ Recipe added successfully');
        return recipe;
      } else {
        print('❗ Unexpected data format: $data');
      }
    } else {
      print('❗ Unexpected response: ${response.data}');
    }
  } catch (e) {
    debugPrint("❌ Error in addRecipe: $e");
    print("Fetch error: $e");
  }

  return null;
}


Future<void> deleteRecipe(String id, SignInViewModel signInViewModel) async {
  try {
    final response = await _dio.delete(
      "/recipes/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer ${signInViewModel.idToken}',
        },
      ),
    );
    if (response.statusCode == 200) {
      print('Recipe deleted successfully');
    } else {
      print('Failed to delete recipe: ${response.data}');
    }
  } catch (e) {
    print('error to delete recipe: $e');
  }
}

}
