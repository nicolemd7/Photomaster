final String Tableimage = 'images';

class ImageFields {
  static int id;
  static String path;
  static int tag;
}

class Image {
  int id;
  String path;
  int tag;

  Image({this.id, this.path, this.tag});

  Image.fromMap(dynamic obj) {
    this.id = obj['imageId'];
    this.path = obj['imagePath'];
    this.tag = obj['FK_image_tags'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'imageId': id,
      'imagePath': path,
      'FK_contact_category': tag,
    };

    return map;
  }
}
