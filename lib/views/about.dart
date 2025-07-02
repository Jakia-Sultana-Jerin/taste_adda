import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Taste Adda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/splash_image.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Taste Adda',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Taste Adda helps you discover, share and save delicious recipes from around the world. Whether you\'re a home cook or a foodie, Taste Adda brings the community together to celebrate good food!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
          
          
            const SizedBox(height: 30),
            const Text(
              'Developed by Taste Adda Team © 2025',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
