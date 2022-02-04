import 'package:flutter/material.dart';
import 'package:photomaster/Screens/Tags.dart';
import 'package:photomaster/Screens/home.dart';
import 'package:photomaster/Screens/gallery.dart';
import 'package:provider/provider.dart';
import 'package:photomaster/albums/main2.dart';

void main() {
  runApp(Photomaster());
}

class Photomaster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        GalleryScreen.id: (context) => GalleryScreen(),
        Main2.id: (context) => Main2(),
        Tags.id: (context) => Tags(),
      },
    );
  }
}
