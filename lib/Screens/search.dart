import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photomaster/Screens/duplicate_detection.dart';
import 'package:photomaster/data/image_operations.dart';
import 'package:photomaster/data/tags_operations.dart';
import 'package:photomaster/models/tags.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<List<String>> assets;
  List<String> a;
  final searchController = TextEditingController();

  TagsOperations tagOp = TagsOperations();
  ImageOperations _imageOperations = ImageOperations();

  void initState() {
    super.initState();
    assets = getPaths();
  }

  Future<List<String>> getPaths() async {
    List<String> a = [];
    _imageOperations.getAllImages().then((value) => {
          value.forEach((element) {
            a.add(element.path);
          })
        });
    return a;
  }

  Future<List<String>> searchImageDB() async {
    print(searchController.text);
    List<String> a = [];
    try {
      var tags = await tagOp.fetchTagWithName(searchController.text);
      print(tags.id);
      var transaction = await tagOp.fetchImageIDWithTagID(tags.id);
      for (Tag id in transaction) {
        var image = await tagOp.fetchImageIDWithImageID(id.id);
        setState(() {
          a.add(image.name);
          var distinctIds = a.toSet().toList();
          a = distinctIds;
          print('asset: $assets');
        });
      }
    } catch (e) {
      setState(() {
        assets = getPaths();
        a = [];
      });
      print("asset not found");
    }
    return a;
  }

  void searchImage() {
    assets = searchImageDB();
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
              width: MediaQuery.of(context).size.width,
              color: Colors.black87,
              child: FutureBuilder(
                future: assets,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
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
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetail(img: a[index],)));
                          },
                          child: Image.file(
                            File(a[index]),
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace stackTrace) {
                              return Container(width: 0.0, height: 0.0);
                            },
                          ),
                        );
                      },
                    );
                  } else
                    return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
