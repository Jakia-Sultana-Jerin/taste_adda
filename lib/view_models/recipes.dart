import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipesViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  List<RecipeModel> _recipes = [];
  Future<void>? _recipesFuture;

  List<RecipeModel> get recipes => _recipes;
  Future<void> get recipesFuture => _recipesFuture ??= fetchRecipes();

  Future<void> fetchRecipes() async {
    try {
      final response = await _dio.get("https://api.npoint.io/416d7e3a1b58126c480f");
      if (response.statusCode == 200 && response.data['error'] == false) {
        final List<dynamic> dataList = response.data['data'];
        _recipes = dataList.map((json) => RecipeModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }
}
