import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:forui/forui.dart';
import 'package:taste_adda/view_models/review.dart';
import 'package:taste_adda/view_models/sign_in_view_model.dart';
import 'package:taste_adda/view_models/user_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeDetailsPage extends StatefulWidget {
  final String id;

  const RecipeDetailsPage({super.key, required this.id});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  bool showcard = false;
  double userrating = 0;
  bool isscrollcontrolled = false;

  @override
  Widget build(BuildContext context) {
    final signInViewModel = Provider.of<SignInViewModel>(
      context,
      listen: false,
    );
    final idToken = signInViewModel.idToken;
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
    final recipe = recipeViewModel.recipe;
    print(widget.id);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: Future.wait([
            recipeViewModel.fetchRecipe(id: widget.id),
            userViewModel.fetchUser(idToken!),
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
            return FutureBuilder<void>(
              future: reviewViewModel.fetchRecipeById(widget.id),
              builder: (context, reviewSnapshot) {
                if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (reviewSnapshot.hasError) {
                  return const Center(child: Text("Reviews load failed"));
                }

                // if (reviewViewModel.review.isEmpty) {
                //   return Center(
                //     child: Text(
                //       "No reviews found",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   );
                // }

                final review = reviewViewModel.review;
                final recipe = recipeViewModel.recipe!;
                return buildRecipeDetails(
                  context,
                  recipeViewModel,
                  userViewModel,
                  reviewViewModel,
                  isexpanded,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildRecipeDetails(
    BuildContext context,
    RecipeViewModel recipeViewModel,
    UserViewModel userViewModel,
    ReviewViewModel reviewViewModel,
    bool isexpanded,
  ) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      color: const Color.fromARGB(255, 255, 144, 64),
      backgroundColor: Colors.black,
      height: 150,
      animSpeedFactor: 5,
      onRefresh: () async {
        await Future.wait([
          recipeViewModel.fetchRecipe(id: recipeViewModel.recipe!.id),
          userViewModel.fetchUser(userViewModel.user!.id),
          reviewViewModel.fetchRecipeById(recipeViewModel.recipe!.id),
        ]);
      },
      child: SingleChildScrollView(
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
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/userprofile');
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        userViewModel.user!.profilePicture,
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push('/userprofile');
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
                color: FTheme.of(context).dividerStyles.horizontalStyle.color,
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
            ),

            FDivider(
              style: FDividerStyle(
                color: FTheme.of(context).dividerStyles.horizontalStyle.color,
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
                color: FTheme.of(context).dividerStyles.horizontalStyle.color,
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
                            final step = recipeViewModel.recipe!.steps[index];
                            return FAccordionItem(
                              title: Text(
                                'Step ${index + 1}',
                                style: TextStyle(color: Colors.orangeAccent),
                              ),
                              child: Text(step, style: TextStyle(fontSize: 15)),
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
                color: FTheme.of(context).dividerStyles.horizontalStyle.color,
                padding: EdgeInsets.zero,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  reviewViewModel.review.isEmpty
                      ? Text(
                        "No reviews found",
                        style: TextStyle(color: Colors.white70),
                      )
                      : FTileGroup(
                        children: List.generate(reviewViewModel.review.length, (
                          index,
                        ) {
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
                                userViewModel.user!.profilePicture,
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
                        }),
                      ),
            ),

            FButton(
              style: FButtonStyle.primary,
              intrinsicWidth: true,
              onPress: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // বড় হলে Scroll হবে
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    final feedbackController = TextEditingController();
                    double rating = 3.0;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 50,
                                    height: 5,
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Leave a quick feedback!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: feedbackController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    hintText: 'Write your review here...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Rate the recipe:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  maxRating: 5,
                                  allowHalfRating: true,
                                  itemBuilder:
                                      (context, _) => Icon(
                                        LucideIcons.star,
                                        color: Colors.orangeAccent,
                                      ),
                                  onRatingUpdate: (newRating) {
                                    setState(() {
                                      rating = newRating;
                                    });
                                  },
                                  itemSize: 30,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FButton(
                                      style: FButtonStyle.outline,
                                      onPress: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(width: 10),
                                    FButton(
                                      style: FButtonStyle.primary,
                                      onPress: () async {
                                        final review =
                                            feedbackController.text.trim();
                                        if (review.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Please enter your review',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        print(
                                          'Review: $review, Rating: $rating',
                                        );

                                        final idToken =
                                            await FirebaseAuth
                                                .instance
                                                .currentUser
                                                ?.getIdToken();

                                        final reviews = await reviewViewModel
                                            .submitReview(
                                              id: recipeViewModel.recipe!.id,
                                              user:
                                                  userViewModel.user!.userName,
                                              description:
                                                  feedbackController.text
                                                      .trim(),
                                              profilePic:
                                                  userViewModel
                                                      .user!
                                                      .profilePicture,

                                              rating: rating,
                                            );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Submit'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              child: const Text('Leave a quick review!'),
            ),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: FButton(
            //         style: FButtonStyle.primary,
            //         intrinsicWidth: true,
            //         onPress: () {
            //           showDialog(context: context, builder: (context) {});
            //         },

            //         child: const Text('Leave a quick review!'),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
