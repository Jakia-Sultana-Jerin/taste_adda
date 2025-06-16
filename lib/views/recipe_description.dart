import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:taste_adda/view_models/user_view_model.dart';

class RecipeDescription extends StatelessWidget {
  final String description;
  final String id;

  const RecipeDescription({
    super.key,
    required this.description,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(
      context,
      listen: false,
    );
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final ValueNotifier<bool> isDescriptionExpanded = ValueNotifier(false);
    var isexpanded = isDescriptionExpanded.value;
    print(id);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: Future.wait([
            recipeViewModel.fetchRecipe(id: id),
            userViewModel.fetchUser(id: '1'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading recipe",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Check if recipe is null

            if (recipeViewModel.recipe == null) {
              return const Center(
                child: Text(
                  "No recipe found",
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

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final text = recipeViewModel.recipe!.description;
                  final textSpan = TextSpan(
                    text: text,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  );

                  final tp = TextPainter(
                    text: textSpan,
                    maxLines: 3,
                    textDirection: TextDirection.ltr,
                  );

                  tp.layout(maxWidth: constraints.maxWidth);
                  final isOverflow = tp.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: isexpanded ? null : 3,
                        overflow:
                            isexpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      if (isOverflow)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    backgroundColor: Colors.black,
                                    content: Text(
                                      text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "close",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          child: const Text(
                            'See more',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
