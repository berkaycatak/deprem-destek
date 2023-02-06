import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsProvider with ChangeNotifier {
  var currentLat;
  var currentLng;
  Position? currentPosition;

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  CameraPosition? kGooglePlex;

  getCurrentPosition() async {
    await Permission.location.request();
    currentPosition = await Geolocator.getCurrentPosition();
    currentLat = currentPosition!.latitude;
    currentLng = currentPosition!.longitude;
    notifyListeners();
    init();
  }

  init() async {
    kGooglePlex = CameraPosition(
      target: LatLng(currentLat, currentLng),
      zoom: 25,
    );
    notifyListeners();
  }
}
