import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:forui/forui.dart';
import 'package:taste_adda/view_models/review.dart';
import 'package:taste_adda/view_models/user_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String id;

  const RecipeDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(
      context,
      listen: false,
    );
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final reviewViewModel = Provider.of<ReviewViewModel>(
      context,
      listen: false,
    );
    final ValueNotifier<bool> isDescriptionExpanded = ValueNotifier(false);
    var isexpanded = isDescriptionExpanded.value;

    //Description Dialog
    // showDialog(
    //   context: context,
    //   builder:
    //       (context) => AlertDialog(
    //         backgroundColor: Colors.black,

    //         content: Text(
    //           recipeViewModel.recipe!.description,
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: Text("close", style: TextStyle(color: Colors.white)),
    //           ),
    //         ],
    //       ),
    // );

    //User Account Details

    print(id);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: Future.wait([
            recipeViewModel.fetchRecipe(id: id),
            userViewModel.fetchUser(id: '1'),
            reviewViewModel.reviewFuture,
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

            if (reviewViewModel.review.isEmpty) {
              return const Center(
                child: Text(
                  "No reviews found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            final review = reviewViewModel.review;

            return SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      recipeViewModel.recipe!.thumbUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                  // Recipe title and thumbnail
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go('/userprofile');
                          },
                          child: CircleAvatar(
                            radius: 20,
                            child: ClipOval(
                              child: Image.network(
                                userViewModel.user!.profilePicture,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                            context.go('/userprofile');
                          },
                            child: Text(
                              recipeViewModel.recipe!.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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

                  ///Recipe-Description
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final text = recipeViewModel.recipe!.description;
                        final textSpan = TextSpan(
                          text: text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
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
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text(
                                                "close",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
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

                  ///Category
                  ///
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        FBadge(
                          style: FBadgeStyle(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.orangeAccent,
                            ),
                            contentStyle: FBadgeContentStyle(
                              labelTextStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          child: Text(recipeViewModel.recipe!.category),
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
                  ////
                  ///
                  ///
                  ///ingredients and steps
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FTabs(
                      children: [
                        FTabEntry(
                          label: const Text('Ingredients'),
                          child: FTileGroup(
                            // label: const Text('Ingredients'),
                            children: List.generate(
                              recipeViewModel.recipe!.ingredients.length,
                              (index) {
                                final ingredientName = recipeViewModel
                                    .recipe!
                                    .ingredients
                                    .keys
                                    .elementAt(index);
                                final ingredientValue =
                                    recipeViewModel
                                        .recipe!
                                        .ingredients[ingredientName];

                                return FTile(
                                  title: Text(ingredientName, maxLines: 2),
                                  details: Text(ingredientValue),
                                  prefixIcon: Icon(
                                    LucideIcons.circleDot,
                                    color: Colors.orangeAccent,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        FTabEntry(
                          label: const Text('Steps'),
                          child: FCard(
                            child: FAccordion(
                              controller: FAccordionController(max: 2),
                              children: List.generate(
                                recipeViewModel.recipe!.steps.length,
                                (index) {
                                  final step =
                                      recipeViewModel.recipe!.steps[index];
                                  return FAccordionItem(
                                    title: Text(
                                      'Step ${index + 1}',
                                      style: TextStyle(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    child: Text(
                                      step,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////Review Section
                  FDivider(
                    style: FDividerStyle(
                      color:
                          FTheme.of(
                            context,
                          ).dividerStyles.horizontalStyle.color,
                      padding: EdgeInsets.zero,
                    ),
                  ),

                  // FButton(
                  //   onPress: () {
                  //     context.go('/review');
                  //   },
                  //   child: const Text(
                  //     'Check Out the Reviews!',
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FTileGroup(
                      children: List.generate(
                        reviewViewModel.review.length,
                        (index) {
                          final review = reviewViewModel.review[index];
                          return FTile(
                            title: Text(
                              review.user,
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              review.description,
                              maxLines: isexpanded ? null : 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                            prefixIcon: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                review.profilepic,
                              ),
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RatingBarIndicator(
                                  rating: double.parse(review.rating),
                                  itemBuilder:
                                      (context, index) => Icon(
                                        LucideIcons.star,
                                        color: Colors.orangeAccent,
                                      ),
                                  itemCount: 5,
                                  itemSize: 15.0,
                                  direction: Axis.horizontal,
                                ),
                                // Icon(
                                //   LucideIcons.star,
                                //   color: Colors.yellowAccent,
                                // ),
                                //  Text(review.rating),
                              ],
                            ),
                          );
                        },
                      ),
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
                          onPress:
                              () => showAdaptiveDialog(
                                context: context,
                                builder:
                                    (context) => FDialog(
                                      direction: Axis.vertical,
                                      title: const Text(
                                        'Was it easy to follow? How did it taste?',
                                      ),
                                      body: const Text(
                                        'Did you enjoy making this recipe? Please,drop your feedback below.Your feedback helps us improve our recipes.',
                                      ),
                                      actions: [
                                        FButton(
                                          onPress: () {},
                                          child: const Text(
                                            'Submit Feedback',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        FButton(
                                          style: FButtonStyle.outline,
                                          onPress: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                              ),
                          child: const Text('Leave a quick review!'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
