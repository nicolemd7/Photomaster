class Tag {
  int id;
  String name;
  Tag({
    this.id,
    this.name,
  });

  Tag.fromMap(dynamic obj) {
    this.id = obj['tagId'];
    this.name = obj['tagName'];
  }

  Tag.fromMaptransaction(dynamic obj) {
    this.id = obj['FimageId'];
  }

  Tag.fromMapimage(dynamic obj) {
    this.name = obj['imagePath'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tagName': name,
    };

    return map;
  }
}
