import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/user_view_model.dart';

class SignInViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _idToken;

  String? get idToken => _idToken;
  final user = FirebaseAuth.instance.currentUser;

  // 🔐 Check if already signed in (no need to navigate here)
  Future<void> checkSignedIn(BuildContext context) async {
    if (_googleSignIn.currentUser != null) {
      context.go('/');
    }
  }

  // Handle Google Sign-In and Firebase Authentication
  Future<void> handleSignIn(BuildContext context) async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      // Trigger the Google Sign-In
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      // Get the authentication credentials from Google
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a Firebase credential
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      // final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      // final idToken = SignInViewModel.idToken;

      User? user = userCredential.user;
      if (user != null) {
        _idToken = await user.getIdToken(true);

        print("✅ Firebase user email: ${user.email}");
        //   print("✅ Firebase user name: ${user.displayName}");
        print("✅ Firebase user ID token: $_idToken");

        await userViewModel.addUser({'email': user.email}, _idToken!);

        context.push('/recipes');
        notifyListeners();

        print("...................................");
        print("Signed in as: ${user.email ?? user.uid}");
        print("...................................");
        print("REAL ID TOKEN: $_idToken");
        print("ID Token: $_idToken");
      }
      // ignore: use_build_context_synchronously
    } catch (error) {
      print("Error during sign-in: $error");
    }
  }
    Future<void> signOut(BuildContext context) async {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      _idToken= null;
      notifyListeners();

      context.go('/SignInPage');
    }
  }

