import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taste_adda/models/recipe_model.dart';

class RecipeViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  RecipeModel? _recipe;
  // Future<void>? _recipeFuture;

  RecipeModel? get recipe => _recipe;

  // You can initialize this with a specific id when needed
  Future<void> fetchRecipe({required String id}) async {
    try {
      final response = await _dio.get("https://api.npoint.io/3be1b04256d85515a067?recipe=$id");

      if (response.statusCode == 200 && response.data['error'] == false) {
        final data = response.data['data'] as List<dynamic>;
   
         // Find recipe by ID
      final recipeJson= data.firstWhere(
        (item) => item['id'].toString() == id,
        orElse: () => null,
      );
   _recipe = RecipeModel.fromJson(recipeJson as Map<String,dynamic>);
        notifyListeners();
      } else {
        print("API returned an error: ${response.data}");
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }
}
