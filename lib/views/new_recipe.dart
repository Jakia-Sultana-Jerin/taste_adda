import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/sign_in_view_model.dart';
import 'package:taste_adda/view_models/user_view_model.dart';
import 'package:taste_adda/view_models/recipes.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({super.key});

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final thumbUrlController = TextEditingController();
  final stepController = TextEditingController();
  final categoryController = TextEditingController();
  final ingredientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final recipesViewModel = Provider.of<RecipesViewModel>(
      context,
      listen: false,
    );
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final signInViewModel = Provider.of<SignInViewModel>(
      context,
      listen: false,
    );
    //final vm=context.watch<RecipesViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(toolbarHeight: 35, title: const Text("Add New Recipe")),
      body: FutureBuilder(
        future: Future.wait([
          recipesViewModel.fetchRecipes(),
          userViewModel.fetchUser(userViewModel.user?.id ?? ''),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recipesViewModel.recipes.isEmpty) {
            return const Center(
              child: Text(
                "No recipes found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (userViewModel.user == null) {
            return const Center(
              child: Text(
                "No user found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final recipes = recipesViewModel.recipes;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Recipe Title",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: thumbUrlController,
                        decoration: const InputDecoration(
                          labelText: "Image URL",
                        ),
                         keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: stepController,
                        decoration: const InputDecoration(
                          labelText: "Steps (comma separated)",
                        ),
                         keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: ingredientController,
                        decoration: const InputDecoration(
                          labelText: "Ingredients (comma separated)",
                        ),
                         keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryController,
                        decoration: const InputDecoration(
                          labelText: "Category",
                        ),
                        
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          // Parse steps and ingredients
                          final steps =
                              stepController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList();
                          final ingredientsList =
                              ingredientController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList();

                          final ingredients = <String, String>{};

                          for (var item in ingredientsList) {
                            if (item.contains(':')) {
                              final parts = item.split(':');
                              final key = parts[0].trim();
                              final value =
                                  parts
                                      .sublist(1)
                                      .join(':')
                                      .trim(); // In case value has `:` too
                              if (key.isNotEmpty && value.isNotEmpty) {
                                ingredients[key] = value;
                              }
                            }
                          }

                          final newRecipe = await recipesViewModel.addRecipe(
                            titleController.text,
                            descController.text,
                            thumbUrlController.text,
                            steps,
                            ingredients,
                            categoryController.text,
                            signInViewModel,
                          );

                          if (newRecipe != null && mounted) {
                            await recipesViewModel.fetchRecipes();
                            context.go('/recipes/${newRecipe.id}');
                            // fetch latest list
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => RecipeDetailsPage(id: newRecipe.id ?? ""),
                            //   ),
                            // );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Recipe Added!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to add')),
                            );
                          }
                          debugPrint(
                            "Latest recipes count: ${recipesViewModel.recipes.length}",
                          );
                          for (var r in recipesViewModel.recipes) {
                            debugPrint("Recipe: ${r.title}");
                          }
                          debugPrint(
                            'Number of recipes: ${recipesViewModel.recipes.length}',
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
