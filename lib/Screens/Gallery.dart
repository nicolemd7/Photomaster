import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photomaster/Enhancements/ApplyFilters.dart';
import 'package:photomaster/Enhancements/EditImg.dart';
import 'package:photomaster/Enhancements/SaveInGallery.dart';
import 'package:photomaster/Enhancements/main3.dart';
import 'package:photomaster/Screens/tags_test.dart';
import 'package:photomaster/albums/main2.dart';
import 'package:photomaster/data/database.dart';
import 'package:photomaster/data/image_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photomaster/Screens/Images_Details.dart';
import 'package:photomaster/Screens/Tags.dart';
import 'package:photomaster/data/tags_operations.dart';
import 'package:photomaster/models/tags.dart';
import 'package:video_player/video_player.dart';
import 'package:photomaster/Enhancements/GetImg.dart';

class TagStateController extends GetxController {
  var ListTags = List<String>.empty(growable: true).obs;
}

class GalleryScreen extends StatefulWidget {
  static const String id = "gallery_screen";
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int currentIndex = 0;


  void OnSelected(BuildContext context, int item)async{
    switch(item){
      case 0:
        File _edit_image;
        var _Ifile = await GetiImg(_edit_image); // function called from GetImg.dart
        if (_Ifile != null) {
          setState(() async {
            _edit_image = _Ifile;
            if (_edit_image != null) {
              var _Ifile = await EditImg(_edit_image); // function called from EditImg.dart
              if (_Ifile != null) {
                setState(() {
                  _edit_image = _Ifile;
                });
                if (_edit_image != null) {
                  await SaveImg(_edit_image); // function called from SaveInGallery.dart
                } else {
                  Fluttertoast.showToast(
                      msg: "Select a image first :-(",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }
            }
          });
        }
        break;
      case 1:
        File _filter_image;
        var _Ifile_filter = await GetiImg(_filter_image);
        if (_Ifile_filter != null) {
          var _Ifile = await ApplyFilters(context, _Ifile_filter);
          if (_Ifile != null) {
            setState(() {
              _filter_image = _Ifile;
            });
            if (_filter_image != null) {
              await SaveImg(_filter_image);
            } else {
              Fluttertoast.showToast(
                  msg: "Select a image first :-(",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        }
        break;
    }
  }

  final screens = [
    grid_gallary(),
    MyHomePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Gallery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
              onSelected: (item) => OnSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text("Edit"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("Filter"),
                ),
              ]
              ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) => setState(()=>{currentIndex = index}),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Gallery",
            backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_album_rounded),
              label: "Album",
            backgroundColor: Colors.black
          ),
        ],
      ),
      body: screens[currentIndex]
    );
  }
}

class grid_gallary extends StatefulWidget {
  @override
  State<grid_gallary> createState() => _grid_gallaryState();
}

class _grid_gallaryState extends State<grid_gallary> {
  List<AssetEntity> assets = [];
  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  @override
  Widget build(BuildContext context) {
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
      itemCount: assets.length,
      itemBuilder: (BuildContext context, index) {
        return AssetThumbnail(asset: assets[index]);
      },
    );
  }
}


class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future

    final controller = Get.put(TagStateController());
    final textController = TextEditingController();
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  if (asset.type == AssetType.image) {
                    var imageDetails = ImageDetails(
                      img: asset.file,
                      img_path: asset.relativePath,
                      img_id: asset.id.toString(),
                      img_tags: ChipDemo(id: asset.id),
                    );
                    TagsOperations to = TagsOperations();
                    to.assignTag(imageDetails);
                    return imageDetails;
                  } else {
                    // if it's not, navigate to VideoScreen
                    return VideoScreen(videoFile: asset.file);
                  }
                },
              ),
            );
          },
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (asset.type == AssetType.video)
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key key,
    @required this.imageFile,
  }) : super(key: key);

  final Future<File> imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey,
          height: 400,
          alignment: Alignment.center,
          child: FutureBuilder<File>(
            future: imageFile,
            builder: (_, snapshot) {
              final file = snapshot.data;
              if (file == null) return Container();
              return Image.file(file);
            },
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // Container(
        //   color: Colors.pink,
        //   height: 50,
        // )
      ],
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key key,
    @required this.videoFile,
  }) : super(key: key);

  final Future<File> videoFile;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initVideo() async {
    final video = await widget.videoFile;
    _controller = VideoPlayerController.file(video)
      // Play the video again when it ends
      ..setLooping(true)
      // initialize the controller and notify UI when done
      ..initialize().then((_) => setState(() => initialized = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialized
          // If the video is initialized, display it
          ? Scaffold(
              body: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                    }
                  });
                },
                // Display the correct icon depending on the state of the player.
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            )
          // If the video is not yet initialized, display a spinner
          : Center(child: CircularProgressIndicator()),
    );
  }
}
