import 'package:taste_adda/models/review_model.dart';

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String thumbUrl;
  final Map<String, dynamic> ingredients;
  final List<String> steps;
  final String category;
  final List<ReviewModel> reviews;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbUrl,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.reviews,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbUrl: json['thumbUrl'] ?? '',
      ingredients: Map<String, String>.from(json['ingredients'] ?? {}),
      steps: List<String>.from(json['steps'] ?? []),
      category: json['category'] ?? '',
      reviews:
          (json['reviews'] as List<dynamic>? ?? [])
              .map((review) => ReviewModel.fromJson(review))
              .toList(),
    );
  }
}
