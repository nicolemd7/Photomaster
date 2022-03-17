import 'package:photomaster/data/image_operations.dart';
import 'package:photomaster/models/tags.dart';

final String Tableimage = 'images';

class ImageFields {
  static int id;
  static String path;
  static int tag;
}

class ImageDetails {   // TODO: Add Change Notifier
  final String id;
  final String path;
  List<Tag> tag;
  bool inDatabase;

  set setStatus(bool status) {
    this.inDatabase = status;
  }

  ImageDetails.copy({this.id, this.path, this.tag, this.inDatabase = false});

  ImageDetails({this.id, this.path}) {
    tag = [];
    inDatabase = false;
  }
    //TODO: check if image with id is in database
    //TODO: If image does not exist - set inDatabase to false
    //TODO: If image exists - fetch any existing tags for that image

  loadTags() async {
    var _imgOps = ImageOperations();
    List<dynamic> res = await _imgOps.getAllTagsFor(this.id);
  }

  addImage() async {

  }

  static fromMap(dynamic obj) {
    String id = obj['imageId'];
    String path = obj['imagePath'];
//    List<int> tags = obj['FK_image_tags'];
    var tags = obj['FK_image_tags'];
    //TODO: Process tags to convert from int to Tag objects
    return ImageDetails.copy(id: id, path: path, tag: tags, inDatabase: true);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'imageId': id,
      'imagePath': path,
    };

    return map;
  }
}
