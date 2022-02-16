import 'package:flutter/material.dart';
import 'package:photomaster/Enhancements/main3.dart';
import 'package:photomaster/Screens/Tags.dart';
import 'package:photomaster/Screens/home.dart';
import 'package:photomaster/Screens/gallery.dart';
import 'package:photomaster/Screens/splash_screen.dart';
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
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        GalleryScreen.id: (context) => GalleryScreen(),
        Main2.id: (context) => Main2(),
        Tags.id: (context) => Tags(),
        Main3.id: (context) => Main3(),
      },
    );
  }
}
