import 'package:flutter/material.dart';
import 'package:photomaster/Screens/home.dart';
import 'package:photomaster/Screens/gallery.dart';
import 'package:photomaster/db/tagging_database.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Photomaster());
}

class Photomaster extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        GalleryScreen.id: (context) => GalleryScreen(),
      },
    );
  }
}
