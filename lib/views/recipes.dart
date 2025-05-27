import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipes.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesViewModel = Provider.of<RecipesViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Recipes")),
      body: FutureBuilder(
        future: recipesViewModel.recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recipesViewModel.recipes.isEmpty) {
            return const Center(child: Text("No recipes found", style: TextStyle(color: Colors.white),),);
          }

          final recipes = recipesViewModel.recipes;
 //         print("________________________________");
          print(recipes.length.toString());

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/recipe?id='+recipe.id);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Image.network(
                          recipe.thumbUrl,
                          fit: BoxFit.cover,
                          width: 300,
                          height: 250,
                        ),
                      ),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(recipe.thumbUrl),
                        ),
                        Title(
                          color: Colors.black,
                          child: Text(recipe.title),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/recipe');
        },
        shape: CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 255, 144, 64),
        child: Icon(Icons.add),
      ),
    );
  }
}
