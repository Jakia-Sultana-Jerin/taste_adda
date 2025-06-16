import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/user_view_model.dart';

class ProfilePage extends StatefulWidget {
  // final String id;

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Profile Setting')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  ' Your privacy matters,control your own data here.',

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 70,

                    child: ClipOval(
                      child: Image.network(userViewModel.user!.profilePicture),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FCard(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FTextField(
                          controller: _controller,
                          label: const Text(
                            'Username',
                            style: TextStyle(fontSize: 18),
                          ),
                          hint: 'JaneDoe',
                          //   description: const Text('Please enter your username.', style: TextStyle(fontSize: 15, color: Colors.white)),
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FTextField(
                          controller: _controller,
                          label: const Text(
                            'Email',
                            style: TextStyle(fontSize: 18),
                          ),
                          hint: 'example@gmail.com',
                          //     description: const Text('Please enter your e-mail.', style: TextStyle(fontSize: 15, color: Colors.white)),
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FTextField(
                          controller: _controller,
                          label: const Text(
                            'Phone Number',
                            style: TextStyle(fontSize: 18),
                          ),
                          hint: '+8800000000000',
                          //     description: const Text('Please enter your e-mail.', style: TextStyle(fontSize: 15, color: Colors.white)),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: FButton(
                  style: FButtonStyle.secondary,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                      
                            content: Text(
                              'Are you sure you want to save the changes?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                    );
                  },

                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child:  FTile(
                //         prefixIcon: Icon(LucideIcons.settings, size: 22),
                //         title: const Text(
                //           'General',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(FIcons.chevronRight),
                //         onPress: () {
                //          context.go('/general-setting');
                //         },
                //       ),
                
                // ),

                //     Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child:  FTile(
                //         prefixIcon: Icon(LucideIcons.userCircle, size: 22),
                //         title: const Text(
                //           'Profile setting',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(FIcons.chevronRight),
                //         onPress: () {
                //           context.go('/profile-setting');
                //         },
                //       ),
                
                // ),

                //     Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: FTile(
                //         prefixIcon: Icon(LucideIcons.userCog, size: 22),
                //         title: const Text(
                //           'Account setup',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(FIcons.chevronRight),
                //         onPress: () {},
                //       ),
                
                // ),

                //     Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child:  FTile(
                //         prefixIcon: Icon(LucideIcons.bellRing, size: 22),
                //         title: const Text(
                //           'Notifications',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(LucideIcons.chevronRight),
                //         onPress: () {},
                //       ),
                
                // ),

                //     Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child:  FTile(
                //         prefixIcon: Icon(LucideIcons.bookOpenCheck, size: 22),
                //         title: const Text(
                //           'Privacy policy',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(FIcons.chevronRight),
                //         onPress: () {},
                //       ),


                
                // ),


                //   Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child:    FTile(
                //         prefixIcon: Icon(LucideIcons.download, size: 22),
                //         title: const Text(
                //           'Download',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(FIcons.chevronRight),
                //         onPress: () {
                //        //   context.go('/general-setting');
                //         },
                //       ),

                      
                
                // ),

                
                //   Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child:    FTile(
                //         prefixIcon: Icon(LucideIcons.logOut, size: 22),
                //         title: const Text(
                //           'Logout',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //         suffixIcon: Icon(FIcons.chevronRight),
                //         onPress: () {},
                //       ),

                      
                
                // ),
      