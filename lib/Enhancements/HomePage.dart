import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:photomaster/Enhancements/ApplyFilters.dart';
import 'package:photomaster/Enhancements/EditImg.dart';

import 'dart:io';

import 'package:photomaster/Enhancements/GetImg.dart';
import 'package:photomaster/Enhancements/SaveInGallery.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _selected = false; //to check if a image is selected or not
  File _image; //here we will store the selected image and apply modifications
  double _ImageContainerHeight=450, _ImageContainerWidth=400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Image Editor'),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
              height: _ImageContainerHeight,
              width: _ImageContainerWidth,
              child: _selected // checks if a image is selected or not
                  ? Image.file(_image)
                  : Image.network('https://i.pinimg.com/originals/bd/da/f0/bddaf094aabe33a79e2e965a938a3233.png')),
          Row(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              RaisedButton(
                  color: Colors.yellow[900],
                  child: Text(
                    'Get_Image', // to select a image from gallery
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    var _Ifile = await GetiImg(_image); // function called from GetImg.dart
                    if (_Ifile != null) {
                      setState(() {
                        _image = _Ifile;
                        _selected = true;
                      });
                    }
                  }),
              Spacer(
                flex: 1,
              ),
              RaisedButton(
                  color: Colors.yellow[900],
                  child: Text(
                    'Edit Image', //to start editing the shape, size, etc of the selected image
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_image != null) {
                      var _Ifile = await EditImg(_image); // function called from EditImg.dart
                      if (_Ifile != null) {
                        setState(() {
                          _image = _Ifile;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Select a image first :-(",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.yellow[900],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
              Spacer(
                flex: 2,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              RaisedButton(
                  color: Colors.yellow[900],
                  child: Text(
                    'Apply Filters', //to start apply various photo filters to the selected image
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_image != null) {
                      var _Ifile = await ApplyFilters(context, _image); // function called from ApplyFilters.dart
                      if (_Ifile != null) {
                        setState(() {
                          _image = _Ifile;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Select a image first :-(",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.yellow[900],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
              Spacer(
                flex: 1,
              ),
              RaisedButton(
                  color: Colors.yellow[900],
                  child: Text(
                    'Download Editted image', //to save the edited  image to gallery
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_image != null) {
                      await SaveImg(_image); // function called from SaveInGallery.dart
                    } else {
                      Fluttertoast.showToast(
                          msg: "Select a image first :-(",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.yellow[900],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ],
      )),
    );
  }
}
