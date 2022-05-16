import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DuplicateDetection extends StatefulWidget {
  @override
  _DuplicateDetectionState createState() => _DuplicateDetectionState();
}

class _DuplicateDetectionState extends State<DuplicateDetection> {
  List<String> assets = [];

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    List<String> a = [];

    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 100000000,
    );

    print(recentAssets.length);
    try {
      for (var i = 0; i < recentAssets.length; i++) {
        if (recentAssets[i].type == AssetType.image) {
          print(
              'date1: ${recentAssets[i].createDateTime}, date2: ${recentAssets[i + 1].createDateTime}');
          print(recentAssets[i]
              .createDateTime
              .difference(recentAssets[i + 1].createDateTime)
              .inMilliseconds);
          if (recentAssets[i]
                  .createDateTime
                  .difference(recentAssets[i + 1].createDateTime)
                  .inMilliseconds <
              1500) {
            final file1 = await recentAssets[i].originFile;
            final file2 = await recentAssets[i + 1].originFile;
            a.add(file1.path);
            a.add(file2.path);
          }
        }
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      assets = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black87,
      child: assets.length == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator()
              ],
            )
          : GridView.builder(
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
              itemCount: assets.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetail(img: assets[index],)));
                  },
                  child: Image.file(
                    File(assets[index]),
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Container(width: 0.0, height: 0.0);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class ImageDetail extends StatefulWidget {
  String img;
  ImageDetail({this.img});

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //image fetch
              Expanded(
                child: Hero(
                  tag: 'img',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      //color: Colors.blueGrey[900],
                      height: MediaQuery.of(context).size.height -120,
                      color: Colors.black,

                      alignment: Alignment.center,
                      child: Image.file(
                        File(widget.img),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height,
                        fit: BoxFit.contain,
                      )
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        height: 50,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.symmetric(vertical: 18),
                        color: Colors.blueGrey[900],
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        height: 50,
                        onPressed: () async {
                          deleteFile(File(widget.img));
                        },
                        padding: EdgeInsets.symmetric(vertical: 18),
                        color: Colors.red[900],
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print(e);
  }
}

