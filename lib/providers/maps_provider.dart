import 'dart:async';
import 'dart:convert';

import 'package:deprem_destek/components/bottom_sheet/bottom_sheet.dart';
import 'package:deprem_destek/models/afetzede_list_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
    markers.clear();
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

  afetzedeStatus(context, AfetzedeLocationListModel afetzedeLocationListModel) {
    http
        .post(Uri.parse('$BASE_URL/pins/edit/status'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            },
            body: jsonEncode(
                {'id': afetzedeLocationListModel.id.toString(), 'status': "1"}))
        .then((value) {
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
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const SizedBox(
                  height: 50,
                  child: Text(
                    'Kurtarıldı olarak işaretlemek istediğinize emin misiniz?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Onayla',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Vazgeç',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).then((value) {
              if (value != null) {
                if (value) {
                  context
                      .read<MapsProvider>()
                      .afetzedeStatus(context, afetzedeLocationListModel);
                  Navigator.of(context).pop();
                }
              }
            });
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.green,
            ),
            child: const Center(
                child: Text(
              'KURTARILDI',
              style: TextStyle(
                color: Colors.white,
              ),
            )),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
