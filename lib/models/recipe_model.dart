class RecipeModel {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final String category;
  final String review;

  RecipeModel(
    {required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.category,
    required  this.review, 
    required this.title,}
  );
}
