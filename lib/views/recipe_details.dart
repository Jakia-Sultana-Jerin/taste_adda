import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:forui/forui.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String id;

  const RecipeDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(
      context,
      listen: false,
    );

    print(id);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: recipeViewModel.fetchRecipe(id: id),
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

            return SingleChildScrollView(
              child: Column(
                //    mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SafeArea(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        recipeViewModel.recipe!.thumbUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            recipeViewModel.recipe!.thumbUrl,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              recipeViewModel.recipe!.description,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              //  overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Title(
                                      color: Colors.white,
                                      child: Text(
                                        'Description of  ${recipeViewModel.recipe!.title}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    content: Text(
                                      recipeViewModel.recipe!.description,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "close",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          icon: Icon(Icons.more_horiz, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                    child: FButton(
                      style: FButtonStyle.ghost,
                     
                      child: const Text('Category',style:TextStyle.new(color: Colors.white)),
                      onPress: () {
                        showFSheet(
                          context: context,
                          useRootNavigator: true,
                          useSafeArea: true,
                          side: FLayout.ttb,
                                     //       transitionAnimationController: AnimationController(duration: Duration(seconds: 2),vsync:,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                recipeViewModel.recipe!.category,
                                style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    // width:5,
                    child: FTabs(
                      children: [
                        FTabEntry(
                          label: const Text('Ingredients'),
                          child: FCard(
                            title: const Text('Ingredients'),

                            subtitle: const Text(
                              "The necessary ingredients are given here for making this recipe.",
                            ),
                            child: SizedBox(
                              height: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount:
                                      recipeViewModel
                                          .recipe!
                                          .ingredients
                                          .length,
                                  itemBuilder: (context, index) {
                                    final ingredientName = recipeViewModel
                                        .recipe!
                                        .ingredients
                                        .keys
                                        .elementAt(index);
                                    final ingredientValue =
                                        recipeViewModel
                                            .recipe!
                                            .ingredients[ingredientName];

                                    return Text(
                                      "$ingredientName: $ingredientValue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        FTabEntry(
                          label: const Text('Steps'),
                          child: FCard(
                            title: const Text('Steps'),
                            subtitle: const Text(
                              'Follow the cooking steps below to prepare the dish perfectly.',
                            ),
                            child: SizedBox(
                              height: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount:
                                      recipeViewModel.recipe!.steps.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      "${index + 1}. ${recipeViewModel.recipe!.steps[index]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FButton(
                        style: FButtonStyle.primary,
                        intrinsicWidth: true,
                        onPress: () => showAdaptiveDialog(
                          context: context,
                          builder: (context) => FDialog(
                            direction: Axis.horizontal,
                            title: const Text('Was it easy to follow? How did it taste?'),
                            body: const Text('Did you enjoy making this recipe? Please,drop your feedback below.Your feedback helps us improve our recipes.'),
                            actions: [
                              FButton(style: FButtonStyle.outline, onPress: (){}, child: const Text('Cancel')),
                              FButton(onPress: (){}, child: const Text('Submit Feedback')),
                            ],
                          ),
                        ),
                        child: const Text('Leave a quick review!'),
                      ),
                    ),
                  ],
                )


                  // Text(
                  //   recipeViewModel.recipe!.title,
                  //   style: TextStyle(fontSize: 20, color: Colors.white),

                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Text(
                  //     recipeViewModel.recipe!.description,
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
