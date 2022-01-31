import 'dart:io';
import 'dart:typed_data';
import 'package:photomaster/data/image_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photomaster/Screens/Images_Details.dart';
import 'package:photomaster/Screens/Tags.dart';
import 'package:video_player/video_player.dart';

// var suggestTag = [
//   "Bird",
//   "Ocean",
//   "Friend",
//   "BestFriend",
//   "Mom",
//   "Dad",
//   "Sibling",
//   "Bestpic"
// ];

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
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                title: Text('Your Tags'),
                trailing: Icon(Icons.payment),
                onTap: () => Navigator.pushNamed(context, Tags.id)),
          ],
        ),
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
                    // return ImageScreen(imageFile: asset.file);
                    return ImageDetails(
                      img: asset.file,
                      img_path: " Image path is " + asset.relativePath,
                      img_tags: "abc",
                    );
                    // return Flexible(
                    //   child: Column(
                    //     children: [
                    //       ImageScreen(imageFile: asset.file),
                    //       Material(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8),
                    //           child: TypeAheadField(
                    //             textFieldConfiguration: TextFieldConfiguration(
                    //                 controller: textController,
                    //                 onEditingComplete: () {
                    //                   controller.ListTags.add(
                    //                       textController.text);
                    //                   textController.clear();
                    //                 },
                    //                 autofocus: false,
                    //                 style: DefaultTextStyle.of(context)
                    //                     .style
                    //                     .copyWith(
                    //                         fontSize: 20,
                    //                         fontStyle: FontStyle.normal),
                    //                 decoration: InputDecoration(
                    //                     border: OutlineInputBorder(),
                    //                     hintText: 'Select or Enter a Tag')),
                    //             suggestionsCallback: (String pattern) {
                    //               return suggestTag.where((e) => e
                    //                   .toLowerCase()
                    //                   .contains(pattern.toLowerCase()));
                    //             },
                    //             onSuggestionSelected: (String suggestion) =>
                    //                 controller.ListTags.add(suggestion),
                    //             itemBuilder:
                    //                 (BuildContext context, String itemData) {
                    //               return ListTile(
                    //                 leading: Icon(Icons.tag),
                    //                 title: Text(itemData),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Obx(() => controller.ListTags.length == 0
                    //           ? Center(
                    //               child: Text('No tag selected'),
                    //             )
                    //           : Material(
                    //               child: Wrap(
                    //                   children: controller.ListTags.map(
                    //                       (element) => Padding(
                    //                           padding:
                    //                               const EdgeInsets.symmetric(
                    //                                   horizontal: 4),
                    //                           child: Chip(
                    //                             label: Text(element),
                    //                             deleteIcon: Icon(Icons.clear),
                    //                             onDeleted: () =>
                    //                                 controller.ListTags.remove(
                    //                                     element),
                    //                           ))).toList()),
                    //             ))
                    //     ],
                    //   ),
                    // );
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
