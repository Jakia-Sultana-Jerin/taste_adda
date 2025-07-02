import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:taste_adda/models/recipe_model.dart';

class RecipeViewModel extends ChangeNotifier {
  late final Dio _dio;
  final baseUrl =
      kIsWeb
          ? 'https://dingo-proper-mistakenly.ngrok-free.app/'
          : 'https://dingo-proper-mistakenly.ngrok-free.app/';

  RecipeViewModel() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 300),
        receiveTimeout: const Duration(seconds: 300),
      ),
    );
  }

  RecipeModel? _recipe;
  RecipeModel? get recipe => _recipe;

  Future<void> fetchRecipe({required id}) async {
    try {
      final response = await _dio.get("/recipes/$id");

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.data}");

      if (response.statusCode == 200 && response.data['error'] == false) {
        final recipeJson = response.data['data'];
        _recipe = RecipeModel.fromJson(recipeJson);
        notifyListeners();
        
      } else {
        print("❗ API returned error: ${response.data}");
      }
    } catch (e) {
      print("❗ Fetch error: $e");
    }
  }
}
