import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsProvider with ChangeNotifier {
  var currentLat;
  var currentLng;
  CameraPosition? currentPosition;

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  getCurrentPosition() async {
    await Permission.location.request();
    Position _position = await Geolocator.getCurrentPosition();
    currentLat = _position.latitude;
    currentLng = _position.longitude;

    currentPosition = CameraPosition(
      target: LatLng(currentLat, currentLng),
      zoom: 25,
    );
  }

  init() async {
    await getCurrentPosition();
    notifyListeners();
  }
}
