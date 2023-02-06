import 'dart:async';
import 'dart:convert';

import 'package:deprem_destek/components/bottom_sheet/bottom_sheet.dart';
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

  _markerAdd(BuildContext context,
      AfetzedeLocationListModel afetzedeLocationListModel) {
    markers.add(
      Marker(
        markerId: MarkerId(afetzedeLocationListModel.id.toString()),
        position: LatLng(
            afetzedeLocationListModel.lat!, afetzedeLocationListModel.lng!),
        onTap: () {
          buildBottomSheet(
            context,
            title: "Afetzede Bilgileri",
            child: afetzedeDetail(context, afetzedeLocationListModel),
          );
        },
      ),
    );
    notifyListeners();
  }

  getCurrentPosition() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

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
        AfetzedeLocationListModel afetzedeLocationListModel =
            AfetzedeLocationListModel.fromJson(element);
        afetzedeList.add(afetzedeLocationListModel);
        _markerAdd(context, afetzedeLocationListModel);
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

  Widget afetzedeDetail(BuildContext context,
      AfetzedeLocationListModel afetzedeLocationListModel) {
    return Column(
      children: [
        ListTile(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Ad Soyad',
              style: TextStyle(color: Colors.black),
            ),
          ),
          subtitle: Text(afetzedeLocationListModel.nameSurname!),
        ),
        ListTile(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Telefon Numarası',
              style: TextStyle(color: Colors.black),
            ),
          ),
          subtitle: Text(afetzedeLocationListModel.phoneNumber!),
        ),
        ListTile(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Afetzede',
              style: TextStyle(color: Colors.black),
            ),
          ),
          subtitle: Text(
            afetzedeLocationListModel.who == 1
                ? "Ben enkazdayım!"
                : "Tanıdığım kişi enkazda.",
          ),
        ),
        ListTile(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Detaylar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          subtitle: Text(afetzedeLocationListModel.description!),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
