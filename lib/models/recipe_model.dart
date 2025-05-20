import 'package:taste_adda/models/review_model.dart';

class RecipeModel {
  final String title;
  final String description;
  final String thumbUrl;
  final List<Map<String, dynamic>> ingredients;
  final List<String> steps;
  final String category;
  final List<ReviewModel> reviews;

  RecipeModel({
    required this.title,
    required this.description,
    required this.thumbUrl,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.reviews,
  });
}
