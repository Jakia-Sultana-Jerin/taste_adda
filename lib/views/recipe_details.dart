import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String id;
  const RecipeDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(context);

    print("...................................");
    print(id);
    return Scaffold(
      body: FutureBuilder(
        future: recipeViewModel.fetchRecipe(id: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && recipeViewModel.recipe == null) {
            return const Center(
              child: Text(
                "No recipe found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [Image.network(recipeViewModel.recipe!.thumbUrl)],
          );
        },
      ),
    );
  }
}
