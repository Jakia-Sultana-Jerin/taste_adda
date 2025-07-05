import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/user_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfilePage> {
  File? _selectedImage;
  String? uploadurl;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final desccontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile Setting')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Your privacy matters, control your own data here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 70,
                    child: ClipOval(
                      child:
                          _selectedImage != null
                              ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              )
                              : userViewModel.user != null &&
                                  userViewModel.user!.profilePicture.isNotEmpty
                              ? Image.network(
                                userViewModel.user!.profilePicture,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              )
                              : const Icon(Icons.person, size: 70),
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
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await pickImageFromGallery();
                          if (pickedFile != null) {
                            final url = await userViewModel
                                .uploadProfilePicture(pickedFile);
                            if (url != null) {
                              setState(() {
                                uploadurl = url;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Uploaded")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(" Upload failed")),
                              );
                            }
                          }
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      controller: countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                    ),

                    const SizedBox(height: 13),
                    TextField(
                      keyboardType: TextInputType.text,
                      maxLines: 10,
                      controller: desccontroller,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final newEmail = emailController.text.trim();
                  final newName = nameController.text.trim();
                  final newPhone = phoneController.text.trim();
                  final newCountry = countryController.text.trim();
                  final newDescription = desccontroller.text.trim();

                  final oldEmail = userViewModel.user!.email.trim();
                  final oldName = userViewModel.user!.userName.trim();
                  final oldPhone = userViewModel.user!.phoneNumber.trim();
                  final oldCountry = userViewModel.user!.country.trim();
                  final oldDescription = userViewModel.user!.description.trim();

                  final isEmailChanged =
                      newEmail.isNotEmpty && newEmail != oldEmail;
                  final isNameChanged =
                      newName.isNotEmpty && newName != oldName;
                  final isPhoneChanged =
                      newPhone.isNotEmpty && newPhone != oldPhone;
                  final isCountryChanged =
                      newCountry.isNotEmpty && newCountry != oldCountry;
                  final isDescriptionChanged =
                      newDescription.isNotEmpty &&
                      newDescription != oldDescription;

                  if (!isEmailChanged &&
                      !isNameChanged &&
                      !isPhoneChanged &&
                      !isCountryChanged &&
                      !isDescriptionChanged 
                      ) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Nothing to update!')),
                    // );
                    return;
                  }

                  final confirm = await showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          content: const Text(
                            'Are you sure you want to save the changes?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                  );

                  if (confirm != true) return;

                  try {
                    if (isEmailChanged) {
                      final googleUser = await GoogleSignIn().signIn();
                      final googleAuth = await googleUser?.authentication;
                      if (googleAuth == null) {
                        throw Exception('Google re-authentication failed');
                      }

                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      final user = FirebaseAuth.instance.currentUser;
                      await user!.reauthenticateWithCredential(credential);
                      await user.updateEmail(newEmail);
                    }

                    final idToken =
                        await FirebaseAuth.instance.currentUser?.getIdToken();
                    final updated = await userViewModel.updateUser({
                      "_id": userViewModel.user!.id,
                      "userName": isNameChanged ? newName : oldName,
                      "email": isEmailChanged ? newEmail : oldEmail,
                      "phoneNumber": isPhoneChanged ? newPhone : oldPhone,
                      "country": isCountryChanged ? newCountry : oldCountry,
                      "description":
                          isDescriptionChanged
                              ? newDescription
                              : oldDescription,
                      "profilePicture":
                          uploadurl ?? userViewModel.user!.profilePicture,
                    }, idToken!);

                    if (updated != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated")),
                      );

                      nameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      countryController.clear();
                      desccontroller.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Update failed")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                  context.push('/profile-setting');
                },

                child: const Text("Update Profile"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _selectedImage = file;
      });
      return file;
    }
    return null;
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
      