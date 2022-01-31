import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageDetails extends StatefulWidget {
  final img;
  final img_path;
  final img_tags;

  ImageDetails({this.img, this.img_path, this.img_tags});

  @override
  _ImageDetailsState createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
                  child: ImageScreen(
                    imageFile: widget.img,
                  ),
                ),
              ),
            ),
            Container(
              height: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          //Image Tags
                          widget.img_tags,
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          //Image Path
                          widget.img_path,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Colors.lightBlueAccent,
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Photomaster"),
    //   ),
    //   body: ListView(
    //     children: <Widget>[
    //       Container(
    //         height: 300.0,
    //         child: GridTile(
    //           child: ImageScreen(
    //             imageFile: widget.img,
    //           ),
    //           footer: GridTile(
    //             child: Container(
    //                 color: Colors.white70,
    //                 child: ListTile(
    //                   leading: Text(
    //                     widget.img_path,
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 16.0,
    //                     ),
    //                   ),
    //                   title: Row(
    //                     children: <Widget>[
    //                       Expanded(
    //                         child: Text(
    //                           widget.img_tags,
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w600,
    //                             color: Colors.grey,
    //                           ),
    //                         ),
    //                       ),
    //                       // Expanded(
    //                       //   child: Text(
    //                       //     "\$" + widget.product.price.toString(),
    //                       //     style: TextStyle(
    //                       //       fontWeight: FontWeight.bold,
    //                       //       color: Colors.red,
    //                       //     ),
    //                       //   ),
    //                       // ),
    //                     ],
    //                   ),
    //                 )),
    //           ),
    //         ),
    //       ),
//           Row(
//             children: <Widget>[
//               //First row of buttons
//               Expanded(
//                 child: MaterialButton(
//                   elevation: 0.2,
//                   color: Colors.white,
//                   onPressed: () {
//                     var sizes = widget.product.sizes;
//                     showGeneralDialog(
//                         context: context,
//                         pageBuilder: (context, anim1, anim2) {},
//                         barrierDismissible: true,
//                         barrierColor: Colors.black.withOpacity(0.4),
//                         barrierLabel: '',
//                         transitionDuration: Duration(milliseconds: 1000),
//                         transitionBuilder: (context, a1, a2, widget) {
//                           final curvedValue =
//                               Curves.easeInOutBack.transform(a1.value) - 1.0;
//                           return Transform(
//                               transform: Matrix4.translationValues(
//                                   0.0, curvedValue * -200, 0.0),
//                               child: Dialog(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 elevation: 24.0,
//                                 child: Container(
//                                   height:
//                                       MediaQuery.of(context).size.height - 450,
//                                   width: MediaQuery.of(context).size.width - 50,
//                                   child: Padding(
//                                       padding: EdgeInsets.all(13.0),
//                                       child: ListView.builder(
//                                           itemCount: sizes.length,
//                                           itemBuilder: (_, index) {
//                                             return FlatButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   sizeBoolean = false;
//                                                 });
//                                                 _size = sizes[index];
//                                                 setState(() {
//                                                   sizeBoolean = true;
//                                                 });
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Text(sizes[index]),
//                                               materialTapTargetSize:
//                                                   MaterialTapTargetSize.padded,
//                                             );
//                                           })),
//                                 ),
//                               ));
//                         });
//                   },
//                   textColor: Colors.grey,
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(child: sizeBoolean ? Text(_size) : Text('Size')),
//                       Expanded(child: Icon(Icons.arrow_drop_down)),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: MaterialButton(
//                   elevation: 0.2,
//                   color: Colors.white,
//                   onPressed: () {
//                     var color = widget.product.color;
//                     showGeneralDialog(
//                         context: context,
//                         pageBuilder: (context, anim1, anim2) {},
//                         barrierDismissible: true,
//                         barrierColor: Colors.black.withOpacity(0.4),
//                         barrierLabel: '',
//                         transitionDuration: Duration(milliseconds: 1000),
//                         transitionBuilder: (context, a1, a2, widget) {
//                           final curvedValue =
//                               Curves.easeInOutBack.transform(a1.value) - 1.0;
//                           return Transform(
//                               transform: Matrix4.translationValues(
//                                   0.0, curvedValue * -200, 0.0),
//                               child: Dialog(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 elevation: 24.0,
//                                 child: Container(
//                                   height:
//                                       MediaQuery.of(context).size.height - 450,
//                                   width: MediaQuery.of(context).size.width - 50,
//                                   child: Padding(
//                                       padding: EdgeInsets.all(13.0),
//                                       child: ListView.builder(
//                                           itemCount: color.length,
//                                           itemBuilder: (_, index) {
//                                             return FlatButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   colorBoolean = false;
//                                                 });
//                                                 _color = color[index];
//                                                 setState(() {
//                                                   colorBoolean = true;
//                                                 });
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Text(color[index]),
//                                               materialTapTargetSize:
//                                                   MaterialTapTargetSize.padded,
//                                             );
//                                           })),
//                                 ),
//                               ));
//                         });
//                   },
//                   textColor: Colors.grey,
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                           child: colorBoolean ? Text(_color) : Text('Color')),
//                       Expanded(child: Icon(Icons.arrow_drop_down)),
//                     ],
//                   ),
//                 ),
//               ),
// //              Expanded(
// //                child: MaterialButton(
// //                  elevation: 0.2,
// //                  color: Colors.white,
// //                  onPressed: () {
// //                    showDialog(
// //                        context: context,
// //                        builder: (context) {
// //                          return AlertDialog(
// //                            title: Text('Quantity'),
// //                            content: Text('Choose the quantity'),
// //                            actions: <Widget>[
// //                              MaterialButton(
// //                                child: Text(
// //                                  'Close',
// //                                  style: TextStyle(
// //                                    color: Colors.red,
// //                                  ),
// //                                ),
// //                                onPressed: () {
// //                                  Navigator.pop(context);
// //                                },
// //                              ),
// //                            ],
// //                          );
// //                        });
// //                  },
// //                  textColor: Colors.grey,
// //                  child: Row(
// //                    children: <Widget>[
// //                      Expanded(child: Text('Qty')),
// //                      Expanded(child: Icon(Icons.arrow_drop_down)),
// //                    ],
// //                  ),
// //                ),
// //              ),
//             ],
//           ),
          //Second row of buttons
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       child: MaterialButton(
          //         color: Colors.red,
          //         onPressed: () {},
          //         textColor: Colors.white,
          //         child: Text('Buy Now'),
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () async {
          //         //TODO: add to cart logic
          //         appProvider.changeIsLoading();
          //         bool success = await user.addToCart(
          //             product: widget.product, size: _size, color: _color);
          //         if (success) {
          //           _key.currentState.showSnackBar(SnackBar(
          //             content: Text("Added to Cart!"), //
          //           ));
          //           user.reloadUserModel();
          //           appProvider.changeIsLoading();
          //           return;
          //         } else {
          //           _key.currentState.showSnackBar(SnackBar(
          //             content: Text("Added to Cart!"),
          //           ));
          //           appProvider.changeIsLoading();
          //           return;
          //         }
          //       },
          //       icon: Icon(
          //         Icons.add_shopping_cart,
          //         color: Colors.red,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         if (like) {
          //           setState(() {
          //             like = false;
          //             _favourite.createFav(like);
          //           });
          //         } else {
          //           setState(() {
          //             like = true;
          //             _favourite.createFav(like);
          //           });
          //         }
          //       },
          //       icon: Icon(
          //         like ? Icons.favorite : Icons.favorite_border,
          //         color: Colors.red,
          //       ),
          //     ),
          //   ],
          // ),
          // Divider(),
          // ListTile(
          //   title: Text('Product Details'),
          //   subtitle: Text(widget.product.description),
          // ),
          // Divider(),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         'Product Name',
          //         style: TextStyle(color: Colors.grey),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         widget.product.name,
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         'Product Brand',
          //         style: TextStyle(color: Colors.grey),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         widget.product.brand,
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         'Product Condition',
          //         style: TextStyle(color: Colors.grey),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         'NEW',
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         'Product Quantity Available',
          //         style: TextStyle(color: Colors.grey),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //       child: Text(
          //         widget.product.quantity.toString(),
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ],
          // ),
          // Divider(),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          //   child: Text('Featured Products'),
          // ),
          // //Similar Products
          // Container(
          //   height: 360.0,
          //   child: Similar_Products(),
          // ),
//         ],
//       ),
//     );
//   }
// }

