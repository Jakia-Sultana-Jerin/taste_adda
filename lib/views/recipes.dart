import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipes.dart';
import 'package:taste_adda/view_models/sign_in_view_model.dart';
import 'package:taste_adda/view_models/user_view_model.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});
  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  @override
  Widget build(BuildContext context) {
    final recipesViewModel = Provider.of<RecipesViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
   final signInViewModel = Provider.of<SignInViewModel>(context, listen: false);
   // Get the existing SignInViewModel from the provider
    final signInVM = context.read<SignInViewModel>();
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
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.notifications, color: Colors.white),
                    // ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.search, color: Colors.white),
                    // ),
                    IconButton(
                      onPressed: () {
                        context.push('/setting');
                      },
                      icon: Icon(LucideIcons.settings, color: Colors.white),
                    ),
                  ],
                ),
              ],
          body: FutureBuilder(
            future: Future.wait([
              recipesViewModel.recipesFuture,
              userViewModel.fetchUser(signInViewModel.idToken!),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (recipesViewModel.recipes.isEmpty) {
                print("recipes length: ${recipesViewModel.recipes.length}");
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
              //        final recipeVM = context.watch<RecipesViewModel>();
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
                    print('Recipe thumbUrl: ${recipe.thumbUrl}');
                    return Padding(
                      padding: EdgeInsets.zero,
                      child: Card(
                        margin: EdgeInsets.zero,

                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push('/recipes/${recipe.id}');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),

                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    Uri.encodeFull(recipe.thumbUrl),
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
                                      userViewModel.user!.profilePicture,
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
                            FDivider(
                              style: FDividerStyle(
                                color:
                                    FTheme.of(
                                      context,
                                    ).dividerStyles.horizontalStyle.color,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              backgroundColor: Colors.black,
                                              content: Text(
                                                "Are you sure to delete this recipe?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await recipesViewModel
                                                        .deleteRecipe(
                                                          recipe.id,
                                                         signInViewModel
                                                        );
                                                    setState(() {
                                                      recipes.removeAt(
                                                        index,
                                                      ); // Remove from UI list
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Yes"),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
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
            context.push('/new-recipe');
          },
          shape: CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 255, 144, 64),
          child: Icon(Icons.food_bank_outlined),
        ),
      ),
    );
  }
}
