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
  bool loaded;

  set setStatus(bool status) {
    this.inDatabase = status;
  }

  ImageDetails.copy({this.id, this.path, this.tag, this.inDatabase = false});

  ImageDetails({this.id, this.path}) {
    tag = [];
    inDatabase = false;
    loaded = false;
  }

  loadInfo() async {
    ImageOperations imgOp = ImageOperations();
    // check if image with id is in database
    bool exists = await imgOp.imageExists(this);
    if(!exists) {
      // If image does not exist - set inDatabase to false
      this.inDatabase = false;
    }
    else {
      this.inDatabase = true;
      await imgOp.getAllTagsFor(this);
      //TODO: If image exists - fetch any existing tags for that image
    }
    this.loaded = true;
    print(this.id);
    print(this.path);
    print(this.inDatabase);
    print(this.loaded);
    print(this.tag.length);
    print("-----------------------------");
  }

  loadTags() async {
    var _imgOps = ImageOperations();
    List<dynamic> res = await _imgOps.getAllTagsFor(this);
  }

  addTag(Tag newTag) {
    this.tag.add(newTag);
  }

  resetTag() {
    this.tag = [];
  }

  static fromMap(dynamic obj) {
    String id = obj['imageId'].toString();
    String path = obj['imagePath'];
//    List<int> tags = obj['FK_image_tags'];
    //TODO: Process tags to convert from int to Tag objects
    ImageDetails img = ImageDetails(id: id, path: path);
//    return ImageDetails.copy(id: id, path: path, tag: tags, inDatabase: true);
  return img;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'imageId': id,
      'imagePath': path,
    };
    return map;
  }
}
