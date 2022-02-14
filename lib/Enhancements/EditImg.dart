import 'dart:io';
import 'package:photomaster/Enhancements/GetImg.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

EditImg(_image)async{
  var CroppedImg =await ImageCropper.cropImage(
      sourcePath: _image.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          activeControlsWidgetColor: Colors.yellow[900],
          toolbarColor: Colors.yellow[900],
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
  );
  if(CroppedImg!=null){
    _image=CroppedImg;
    return _image;
  }
  else
    return null;
}
