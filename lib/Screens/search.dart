import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photomaster/data/image_operations.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<List<String>> assets;
  List<String> a;
  final searchController = TextEditingController();
  ImageOperations _imageOperations = ImageOperations();

  Future<List<String>> getPaths() async {
    List<String> a = [];
    _imageOperations.getAllImages().then((value) => {
      value.forEach((element) {
//        print("- ${element.path}");
      a.add('/storage/emulated/0/'+element.path);
      })
    });
    return a;
  }

  void initState() {
    super.initState();
    assets = getPaths();
//    _imageOperations.getAllImages().then((value) => {
//      value.forEach((element) {
//        print("- ${element.path}");
//      })
//    });
//    assets = [
//      '/storage/emulated/0/WhatsApp/Media/WhatsApp Images/IMG-20220510-WA0000.jpg',
//      '/storage/emulated/0/Pictures/6c0aa7d6-a13c-4878-b166-5bd193ca92ad2741328015850164049.jpg'
//    ];
  }

  void searchImage() {
    print(searchController.text);
//    setState(() {
//      if(searchController.text.toLowerCase() == 'cat'){
//        assets = [
//          '/storage/emulated/0/Pictures/da6f56b9-146c-4a51-bc2b-98855d4937d37019447153435646028.jpg'
//        ];
//      }
//      else if(searchController.text.toLowerCase() == 'room'){
//        assets = [
//          '/storage/emulated/0/Pictures/6c0aa7d6-a13c-4878-b166-5bd193ca92ad2741328015850164049.jpg'
//        ];
//      }
//      else {
//        assets = [
//          '/storage/emulated/0/Pictures/da6f56b9-146c-4a51-bc2b-98855d4937d37019447153435646028.jpg',
//          '/storage/emulated/0/Pictures/6c0aa7d6-a13c-4878-b166-5bd193ca92ad2741328015850164049.jpg'
//        ];
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.text,
                controller: searchController,
                onChanged: (value) => searchImage(),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 140 - 70,
              color: Colors.black87,
              child: FutureBuilder(
                future: assets,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    a = snapshot.data;
                    return GridView.builder(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // A grid view with 3 items per row
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2),
                      ),
                      itemCount: a.length,
                      itemBuilder: (BuildContext context, index) {
                        return Image.file(File(a[index]), fit: BoxFit.cover);
                      },
                    );
                  }
                  else return CircularProgressIndicator();
                },
//                child: GridView.builder(
//                  primary: false,
//                  padding: const EdgeInsets.all(20),
//                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    // A grid view with 3 items per row
//                    crossAxisCount: 2,
//                    mainAxisSpacing: 8,
//                    crossAxisSpacing: 8,
//                    childAspectRatio: MediaQuery.of(context).size.width /
//                        (MediaQuery.of(context).size.height / 2),
//                  ),
//                  itemCount: assets.length,
//                  itemBuilder: (BuildContext context, index) {
//                    return Image.file(File(assets[index]), fit: BoxFit.cover);
//                  },
//                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
