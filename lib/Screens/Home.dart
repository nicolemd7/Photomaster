import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photomaster/Screens/gallery.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photomaster"),
      ),
      body: Center(
        child: TextButton(
          child: Text("Open Gallery"),
          onPressed: () async {
            final permitted = await PhotoManager.requestPermission();
            if (!permitted) return;
            Navigator.pushNamed(context, GalleryScreen.id);
          },
        ),
      ),
    );
  }
}
