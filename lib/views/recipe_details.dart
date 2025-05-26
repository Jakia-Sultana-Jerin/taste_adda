import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe_details_view_model.dart';
import 'package:taste_adda/view_models/Recipe_view_model.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipedetailsViewModel = Provider.of<RecipeDetailsViewModel>(context);
    final recipe = recipedetailsViewModel.recipes;

    return Scaffold(
      appBar: AppBar(title: Text("Recipes")),

      body: Container(
        child: ListView.builder(
          itemCount: recipe.length,
          itemBuilder: (context, index) {
            final recipes = recipe[index];
            return Container(
              child: Column(
                children: [
                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
