import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photomaster/Screens/gallery.dart';
import 'package:photomaster/data/database.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Stack(
                children: [
                  Container(
                    width: 309,
                    height: 309,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xfffff4cc),
                    ),
                  ),
                  Positioned(
                    left: 100,
                    top: 150,
                    child: Text(
                      "M",
                      style: TextStyle(
                        color: Color(0xff18191f),
                        fontSize: 120,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 40,
                    child: Text(
                      "P",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 155,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 170,
                    top: 60,
                    child: Container(
                      width: 91,
                      height: 87,
                      child: Stack(
                        children: [Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 94.72,
                              height: 90.94,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(37.49),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x59000000),
                                    blurRadius: 28,
                                    offset: Offset(-12.13, 22.05),
                                  ),
                                ],
                                color: Color(0xffc4c4c4),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 90.31,
                                    height: 86.53,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(37.49),
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Color(0xff232323),
                                          Color(0xff353535)
                                        ],),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 62.64,
                                        height: 60.41,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              37.49),
                                          color: Color(0xff313131),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 67.85,
                                        height: 64.43,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: [
                                              Transform.rotate(
                                                angle: -3.14,
                                                child: Container(
                                                  width: 63.44,
                                                  height: 18.32,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(8),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Color(0xff797979),
                                                        Color(0x00323232)
                                                      ],),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 664.26),
                                              Container(
                                                width: 67.05,
                                                height: 64.43,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                      37.49),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x7f000000),
                                                      blurRadius: 2.21,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Container(
                                                          width: 55.35,
                                                          height: 16.78,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(8),
                                                            gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Color(0xff797979),
                                                                Color(0x00323232)
                                                              ],),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 15.98,
                                                      top: 44.46,
                                                      child: Container(
                                                        width: 29.15,
                                                        height: 1.56,
                                                        color: Color(0xffc0c0c0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 94.72,
                                    height: 90.94,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(37.49),
                                      border: Border.all(
                                        color: Color(0xffc5c59e), width: 2.21,),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x99000000),
                                          blurRadius: 3.31,
                                          offset: Offset(-1.10, 2.21),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 30.51,
                                        height: 28.01,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15.44),
                                          color: Color(0xffe8e8e8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                child: Container(
                                  width: 91,
                                  height: 86.68,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Transform.rotate(
                                          angle: 0.02,
                                          child: Container(
                                            width: 33.68,
                                            height: 12.70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xa8ffffff),
                                                  Color(0x02c4c4c4)
                                                ],),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 196.52),
                                        Opacity(
                                          opacity: 0.50,
                                          child: Container(
                                            width: 90.93,
                                            height: 86.68,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Color(0xffaeaeae),
                                                  Color(0xc4d8d8d8),
                                                  Color(0x00ffffff)
                                                ],),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 196.52),
                                        Opacity(
                                          opacity: 0.80,
                                          child: Container(
                                            width: 40.98,
                                            height: 37.99,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Color(0x9ee1e1e1),
                                                  Color(0x00c4c4c4)
                                                ],),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 96.52),
                                        Container(
                                          width: 74,
                                          height: 30.70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [Color(0x00665757), Color(0x00665757)],),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "FOR ALL YOUR PHOTO NEEDS",
                    style: TextStyle(
                      color: Color(0xff969bab),
                      fontSize: 20,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Photomaster",
                    style: TextStyle(
                      color: Color(0xff18191f),
                      fontSize: 50,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                      )
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FlutterLogo(size: 24),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  final permitted = await PhotoManager.requestPermission();
                  if (!permitted) return;
                  DatabaseRepository db = DatabaseRepository.instance;
                  db.initDatabase();
                  Navigator.pushNamed(context, GalleryScreen.id);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
