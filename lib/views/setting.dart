import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/user_view_model.dart';

class SettingPage extends StatefulWidget {
  // final String id;

  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 70,

                        child: ClipOval(
                          child: Image.network(
                            userViewModel.user!.profilePicture,
                          ),
                        ),
                      ),
                    
                      // Positioned(
                      //   right: 0,
                      //   bottom: 0,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(6),
                      //     decoration: const BoxDecoration(
                      //       color: Colors.black45,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: Icon(
                      //       Icons.camera_alt,
                      //       color: Colors.white,
                      //       size: 30,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                  SizedBox(height:20),
                      Text(userViewModel.user!.userName,style:TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
                SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  FTile(
                        prefixIcon: Icon(LucideIcons.settings, size: 22),
                        title: const Text(
                          'My Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(FIcons.chevronRight),
                        onPress: () {
                         context.push('/general-setting');
                        },
                      ),
                
                ),

                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  FTile(
                        prefixIcon: Icon(LucideIcons.userCircle, size: 22),
                        title: const Text(
                          'Profile setting',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(FIcons.chevronRight),
                        onPress: () {
                          context.push('/profile-setting');
                        },
                      ),
                
                ),

                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FTile(
                        prefixIcon: Icon(LucideIcons.userCog, size: 22),
                        title: const Text(
                          'Account setup',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(FIcons.chevronRight),
                        onPress: () {},
                      ),
                
                ),

                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  FTile(
                        prefixIcon: Icon(LucideIcons.bellRing, size: 22),
                        title: const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(LucideIcons.chevronRight),
                        onPress: () {},
                      ),
                
                ),

                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  FTile(
                        prefixIcon: Icon(LucideIcons.bookOpenCheck, size: 22),
                        title: const Text(
                          'Privacy policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(FIcons.chevronRight),
                        onPress: () {},
                      ),


                
                ),


                  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:    FTile(
                        prefixIcon: Icon(LucideIcons.download, size: 22),
                        title: const Text(
                          'Download',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(FIcons.chevronRight),
                        onPress: () {
                       //   context.go('/general-setting');
                        },
                      ),

                      
                
                ),

                
                  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:    FTile(
                        prefixIcon: Icon(LucideIcons.logOut, size: 22),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        suffixIcon: Icon(FIcons.chevronRight),
                        onPress: () {},
                      ),

                      
                
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
