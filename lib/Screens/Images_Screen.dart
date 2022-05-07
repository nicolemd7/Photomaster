import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:photomaster/Enhancements/EditImg.dart';
import 'package:photomaster/Screens/tag_interface.dart';
import 'package:photomaster/data/image_operations.dart';
import 'package:photomaster/data/tags_operations.dart';
import 'package:flutter/material.dart';
import 'package:photomaster/models/image.dart';
import 'package:photomaster/models/tags.dart';
import 'package:video_player/video_player.dart';
import 'package:photomaster/models/Tags.dart';
import 'package:photomaster/Screens/tags_test.dart';

class ImageScreen extends StatefulWidget {
  final ImageDetails img;
  Future<File> file;

  ImageScreen({this.img, this.file});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  TagsOperations _tagsOperations = TagsOperations();
  bool imageInfoLoaded = false;
//  String abs_path;

//  loadImageInfo() async {
////    abs_path = await FlutterAbsolutePath.getAbsolutePath(widget.img.path+widget.img.id);
//    bool imgExists = await _imgOps.imageExists(widget.img);
//    if(imgExists) {
//      widget.img.setStatus = true;
//      widget.img.loadTags();
//    }
//    setState(() {});
//  }

  @override
  void initState() {
//    loadImageInfo();
    // TODO: set imageInfoLoaded as true and call setState
    super.initState();
  }

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
                      child: FutureBuilder(
                        future: widget.file,
                        builder: (_, file) {
                          if(file.hasData) {
                            if (widget.file == null) return Container();
                            return Image.file(
                              file.data,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height - 120,
                              fit: BoxFit.contain,
                            );
                          }
                          else return Container();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal:20.0),
              //   child: Text(
              //     //Image Path
              //     widget.img_path,
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TagInterface(),
//                  Padding(
//                    child: ChipDemo(id: widget.img.id),
//                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
////                      child: widget.img_tags
//                  )
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

//class ImageScreen extends StatelessWidget {
//  const ImageScreen({
//    Key key,
//    @required this.imageFile,
//  }) : super(key: key);
//
//  final String imageFile;
//
//  @override
//  Widget build(BuildContext context) {
//    return SingleChildScrollView(
//      child: Column(
//        children: [
//          Container(
//            //color: Colors.blueGrey[900],
//            height: MediaQuery.of(context).size.height -120,
//            color: Colors.black,
//
//            alignment: Alignment.center,
//            child: Builder(
//              builder: (_) {
//                final file = File(imageFile);
//                if (file == null) return Container();
//                return Image.file(
//                    file,
//                    height: MediaQuery.of(context).size.height - 120,
//                    fit: BoxFit.contain,
//                );
//              },
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key key,
    this.videoFile,
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
