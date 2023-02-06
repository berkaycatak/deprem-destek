import 'package:deprem_destek/providers/maps_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MapsProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MapsProvider>(context);
    return Scaffold(
      body: provider.currentPosition == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                buildingsEnabled: true,
                initialCameraPosition: provider.currentPosition!,
                onMapCreated: (GoogleMapController controller) {
                  provider.mapController.complete(controller);
                },
              ),
            ),
    );
  }
}
