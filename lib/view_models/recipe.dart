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
      final response = await _dio.get("https://api.npoint.io/7000c8aa88a17af6ef22?recipe=$id");

      if (response.statusCode == 200 && response.data['error'] == false) {
        final data = response.data['data'];
        _recipe = RecipeModel.fromJson(data);
        notifyListeners();
      } else {
        print("API returned an error: ${response.data}");
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }
}
