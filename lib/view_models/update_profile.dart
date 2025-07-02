import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



Future<void> updateFirebaseEmail(String newEmail) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("No user signed in.");
    return;
  }

 
    try {
  final user = FirebaseAuth.instance.currentUser!;
  final googleUser = await GoogleSignIn().signIn();
  final googleAuth = await googleUser!.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  await user.reauthenticateWithCredential(credential);

  await user.updateEmail(newEmail);
  print('✅ Email updated!');
} catch (e) {
  print('❌ Error: $e');
}
   
// // Sign in with Google to get the GoogleSignInAccount
// final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
// if (googleUser == null) {
//   print("Google sign-in aborted.");
//   return;
// }
// GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//     // Create a Firebase credential
//     OAuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     // 2️⃣ Re-authenticate.
//     await user.reauthenticateWithCredential(credential);

//     // 3️⃣ Now safely update email.
//     await user.updateEmail(newEmail);

//     print("Email updated successfully in Firebase Auth.");
//   }
//    on FirebaseAuthException catch (e) {
//     print("Firebase Auth error: ${e.code} ${e.message}");
//     if (e.code == 'requires-recent-login') {
//       print("You must sign in again to change email.");
//     }
//   } catch (e) {
//     print(" Something went wrong: $e");
//   }
}
