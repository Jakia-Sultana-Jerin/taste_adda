import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/sign_in_view_model.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final signInViewModel = Provider.of<SignInViewModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash_image.png"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        "Continue Sign In with",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () async {
                            await signInViewModel.handleSignIn(context);
                          },
                          child: Row(
                            spacing: 10,
                            children: [
                              Image.asset(
                                "assets/images/google_icon.png",
                                height: 30,
                              ),
                              Text(
                                "Sign In with Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          spacing: 10,
                          children: [
                            Image.asset(
                              "assets/images/facebook_icon.png",
                              height: 30,
                            ),
                            Text(
                              "Sign In with Facebook",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
