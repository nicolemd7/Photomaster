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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tagName': name,
    };

    return map;
  }
}
