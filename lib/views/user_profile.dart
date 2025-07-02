import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/recipe.dart';
import 'package:taste_adda/view_models/user_view_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(
      context,
      listen: false,
    );
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool issubscribed = false;
    bool isexpanded = false;
    bool isoverflow = false;

    




    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: Future.wait([
            userViewModel.fetchUser(userViewModel.user?.id ?? ''),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error loading userprofile",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (userViewModel.user == null) {
              return const Center(
                child: Text(
                  "No user found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FCard(
                    image: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            userViewModel.user!.profilePicture,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                    ),
                    title: Text(userViewModel.user!.userName),
                    subtitle: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: Colors.black,
                                content: Text(
                                  userViewModel.user!.description,
                                  style: const TextStyle(color: Colors.white),
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
                      child: Text(
                        userViewModel.user!.description,
                        maxLines: isexpanded ? null : 10,
                        overflow: isexpanded ? null : TextOverflow.ellipsis,
                      ),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Icon(LucideIcons.user),
                            Text(
                              userViewModel.user!.userName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(LucideIcons.mail),
                            Text(
                              userViewModel.user!.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(LucideIcons.phoneCall),
                            Text(
                              userViewModel.user!.phoneNumber,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),
                        Row(
                          spacing: 10,
                          children: [
                            Image.network(
                              'https://flagsapi.com/BD/flat/64.png',
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              userViewModel.user!.country,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Padding(
                        //   padding: const EdgeInsets.all(15.0),
                        //   child: FButton(
                        //     style: FButtonStyle.secondary,
                        //     onPress: () async {
                        //       await OneSignal.Notifications.requestPermission(
                        //         true,
                        //       );

                        //       // Optionally tag user as subscribed
                        //       await OneSignal.User.addTagWithKey(
                        //         "subscribed",
                        //         "true",
                        //       );
                        //       showDialog(
                        //         context: context,
                        //         builder:
                        //             (context) => AlertDialog(
                        //               title: Text("Subscribed!"),
                        //               content: Text(
                        //                 "Thanks for subscribing. Stay tuned!",
                        //               ),
                        //               actions: [
                        //                 TextButton(
                        //                   onPressed:
                        //                       () => Navigator.of(context).pop(),
                        //                   child: Text("OK"),
                        //                 ),
                        //               ],
                        //             ),
                        //       );
                        //       Navigator.of(
                        //         context,
                        //       ).pop(); // Close the profile page

                        //       // Show a local push notification
                        //     },
                        //     child: const Text('Subscribe & Stay Tuned!'),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ); // Replace with your widget tree
  }
}
