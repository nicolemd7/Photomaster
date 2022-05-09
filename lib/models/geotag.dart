class Geotag {
  int id;
  double lat;
  double long;
  Geotag({
    this.id,
    this.lat,
    this.long,
  });

  Geotag.fromMap(dynamic obj) {
    this.id = obj['imageId'];
    this.lat = obj['lat'];
    this.long = obj['long'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'lat': lat,
      'long': long,
    };

    return map;
  }
}
