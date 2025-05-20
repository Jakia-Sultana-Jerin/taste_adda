import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taste_adda/view_models/home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundimage.jpeg"),
            opacity: 0.4,
            repeat: ImageRepeat.repeat,
          ),
        ),

        child: FutureBuilder(
          future: homeViewModel.fetchHome(),
          builder: (context, shapshot) {
            if (shapshot.hasData) {
              return Text("data");
            }
            return Text("data");
          },
        ),
      ),
    );
  }
}
