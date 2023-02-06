import 'dart:async';
import 'dart:convert';

import 'package:deprem_destek/models/afetzede_list_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MapsProvider with ChangeNotifier {
  String BASE_URL = 'https://deprem.medialyra.com/api';
  // ignore: prefer_typing_uninitialized_variables
  var currentLat;
  // ignore: prefer_typing_uninitialized_variables
  var currentLng;
  List<AfetzedeLocationListModel> afetzedeList = [];
  AfetzedeLocationListModel afetzedeLocationListModel =
      AfetzedeLocationListModel();
  CameraPosition? currentPosition;

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  List<Marker> markers = <Marker>[];

  _markerAdd(id, lat, lng) {
    markers.add(Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(lat, lng),
      // infoWindow: InfoWindow(
      // title: 'The title of the marker'
      // )
    ));
    notifyListeners();
  }

  getCurrentPosition() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition();
    currentLat = position.latitude;
    currentLng = position.longitude;

    currentPosition = CameraPosition(
      target: LatLng(currentLat, currentLng),
      zoom: 25,
    );
  }

  init() async {
    await getCurrentPosition();
    notifyListeners();
  }

  getAfetzedeList(context) {
    afetzedeList.clear();
    http.post(Uri.parse('$BASE_URL/pins'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }).then((value) {
      print(value.body);
      for (var element in jsonDecode(value.body) as List) {
        afetzedeList.add(AfetzedeLocationListModel.fromJson(element));
        _markerAdd(element['id'], element['lat'], element['lng']);
      }
      notifyListeners();
    });
  }

  addAfetzede(context, nameSurname, lat, lng, who, phone, description) {
    http
        .post(Uri.parse('$BASE_URL/pins/add'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              'lat': lat,
              'lng': lng,
              'name_surname': nameSurname,
              'phone_number': phone,
              'who': who,
              'description': description
            }))
        .then((value) {
      print(value.body);
      getAfetzedeList(context);
      notifyListeners();
    });
  }
}
