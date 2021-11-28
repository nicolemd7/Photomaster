import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

var suggestTag = [
  "Bird",
  "Ocean",
  "Friend",
  "BestFriend",
  "Mom",
  "Dad",
  "Sibling",
  "Bestpic"
];

class TagStateController extends GetxController {
  var ListTags = List<String>.empty(growable: true).obs;
}

class GalleryScreen extends StatefulWidget {
  static const String id = "gallery_screen";
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // This will hold all the assets we fetched
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // A grid view with 3 items per row
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(asset: assets[index]);
        },
      ),
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
                    // If this is an image, navigate to ImageScreen
                    return Flexible(
                      child: Column(
                        children: [
                          ImageScreen(imageFile: asset.file),
                          Material(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: textController,
                                    onEditingComplete: () {
                                      controller.ListTags.add(
                                          textController.text);
                                      textController.clear();
                                    },
                                    autofocus: false,
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                            fontSize: 20,
                                            fontStyle: FontStyle.normal),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Select or Enter a Tag')),
                                suggestionsCallback: (String pattern) {
                                  return suggestTag.where((e) => e
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()));
                                },
                                onSuggestionSelected: (String suggestion) =>
                                    controller.ListTags.add(suggestion),
                                itemBuilder:
                                    (BuildContext context, String itemData) {
                                  return ListTile(
                                    leading: Icon(Icons.tag),
                                    title: Text(itemData),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() => controller.ListTags.length == 0
                              ? Center(
                                  child: Text('No tag selected'),
                                )
                              : Material(
                                  child: Wrap(
                                      children: controller.ListTags.map(
                                          (element) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Chip(
                                                label: Text(element),
                                                deleteIcon: Icon(Icons.clear),
                                                onDeleted: () =>
                                                    controller.ListTags.remove(
                                                        element),
                                              ))).toList()),
                                ))
                        ],
                      ),
                    );
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
          color: Colors.blue,
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
        //   height: 350,
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
