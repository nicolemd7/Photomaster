import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Future<List<String>> assets2;
  List<String> a;
  String _dropDownValue = 'or';

  final searchController = TextEditingController();
  final searchController_2 = TextEditingController();

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
    print('a $a');
    return a;
  }

  // --------- HELPER ---------
  Future<List<String>> clearPath() async {
    return [];
  }

  Future<List> _fetchList1() {
    return assets;
  }

  Future<List> _fetchList2() {
    return assets2;
  }

  Future<List<String>> list_to_futurelist(List distinctIds) async {
    return distinctIds;
  }

  // ------------------

  Future<List<String>> searchImageDB() async {
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

  Future<List<String>> searchImageDB2() async {
    List<String> a = [];
    try {
      var tags = await tagOp.fetchTagWithName(searchController_2.text);
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
        assets2 = clearPath();
        a = [];
      });
      print("asset not found");
    }
    return a;
  }

  void searchImage() {
    assets = searchImageDB();
  }

  void searchImage2() async {
    if (searchController.text != '') {
      String type = _dropDownValue;
      assets2 = searchImageDB2();
      if (await assets2.then((value) => value.isNotEmpty)) {
        List list1 = await _fetchList1();
        List list2 = await _fetchList2();
        if (type == 'or') {
          List finallist = list1 + list2;
          var distinctIds = finallist.toSet().toList();
          print('distinct list $distinctIds');
          setState(() {
            assets = list_to_futurelist(distinctIds);
          });
        }
        if (type == 'and') {
          List<String> commonElements = [];
          for (var e1 in list1) {
            for (var e2 in list2) {
              if (e1 == e2) {
                commonElements.add(e1);
              }
            }
          }
          setState(() {
            assets = list_to_futurelist(commonElements);
          });
          print('common elements $commonElements');
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "Type search 1 first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    width: MediaQuery.of(context).size.width / 2,
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
                          hintText: "Search 1",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      controller: searchController_2,
                      onChanged: (value) => searchImage2(),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search 2",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    // isExpanded: true,
                    hint: Text(
                      _dropDownValue,
                      style: TextStyle(color: Colors.white),
                    ),
                    // iconSize: 0,
                    items: <String>['or', 'and'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        searchController.clear();
                        searchController_2.clear();
                        assets = getPaths();
                        _dropDownValue = val;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 140 - 70 - 50,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageDetail(
                                          img: a[index],
                                        )));
                          },
                          child: Image.file(
                            File(a[index]),
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
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
