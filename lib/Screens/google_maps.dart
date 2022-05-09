import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photomaster/data/geotags_operations.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController _mapController;
  BitmapDescriptor _sourceIcon;

  List<Marker> myMarker = [];

  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(37.0902, 95.7129), zoom: 2.5);

  Future<void> _onMapcreated(GoogleMapController _ctrl) async {
    changeMapMode();
    _mapController = _ctrl;

    var pos = await getMyPosition();

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 15)));
  }

  changeMapMode() {
    getJsonFile("assets/dark.json").then(setMapStyle);
  }
  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }
  void setMapStyle(String mapStyle) {
    _mapController.setMapStyle(mapStyle);
  }

  Future<LatLng> getMyPosition() async {
    bool locationEnabled;
    LocationPermission permission;

    locationEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      try {
        return LatLng(position.latitude, position.longitude);
      } catch (e) {
        print("error $e");
      }
    } else {
      permission = await Geolocator.requestPermission();
    }
  }

  GeotagsOperations geotagsOperations = GeotagsOperations();

  void initState(){
    getMarkerData();
    _setSourceIcon();
    super.initState();
  }

  void _setSourceIcon() async {
    _sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
  }

  getMarkerData() async {
    List all_tags = await geotagsOperations.getAllGeoTags();
    print("here $all_tags");
    var marker_id = '0';
    print(all_tags.map((e) {
      MarkerId markerId = MarkerId(marker_id);
      print(e.id);
      print(e.lat);
      print(e.long);
      if(e.lat != null || e.long != null){
        final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
              e.lat, e.long),
          icon: _sourceIcon
        );
        print(marker);
        setState(() {
          marker_id = (int.parse(marker_id) + 1).toString();
          myMarker.add(marker);
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: Set.from(myMarker),
        initialCameraPosition: _initialPosition,
        onMapCreated: _onMapcreated,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        onTap: (cordinate) {
          _mapController.animateCamera(CameraUpdate.newLatLng(cordinate));
        },
      ),
    );
  }
}
