import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipes.dart';


class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesViewModel = Provider.of<RecipesViewModel>(context);

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
                SliverAppBar(
                  titleSpacing: 1,
                  toolbarHeight: 40,
                  backgroundColor: Colors.black,
                  leading: SizedBox(
                    width: 60, // Adjust width as needed
                    height: 60, // Adjust height as needed
                    child: Image.asset(
                      'assets/images/splash_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "Taste Adda",
                    style: TextStyle(color: Color.fromARGB(255, 255, 144, 64)),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.menu, color: Colors.white),
                    ),
                  ],
                ),
              ],
          body: FutureBuilder(
            future: recipesViewModel.recipesFuture,
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

              final recipes = recipesViewModel.recipes;

              return LiquidPullToRefresh(
                showChildOpacityTransition: false,
                color: const Color.fromARGB(255, 255, 144, 64),
                backgroundColor: Colors.black,
                height: 150,
                animSpeedFactor: 5,
                onRefresh: recipesViewModel.fetchRecipes,
                child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  itemCount: recipes.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Padding(
                      padding: EdgeInsets.zero,
                      child: Card(
                        margin: EdgeInsets.zero,

                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.go('/recipe?id=${recipe.id}');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    recipe.thumbUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      recipe.thumbUrl,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          recipe.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/new-recipe');
          },
          shape: CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 255, 144, 64),
          child: Icon(Icons.food_bank_outlined),
        ),
      ),
    );
  }
}
