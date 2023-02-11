import 'package:deprem_destek/components/bottom_sheet/bottom_sheet.dart';
import 'package:deprem_destek/providers/maps_provider.dart';
import 'package:deprem_destek/screens/sub/about_screen.dart';
import 'package:deprem_destek/screens/sub/contact_screen.dart';
import 'package:deprem_destek/screens/sub/sss_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool? isAfetzede = false;
  bool? isNotAfetzede = false;

  double? selectedLat;
  double? selectedLng;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MapsProvider>().init();
    context.read<MapsProvider>().getAfetzedeList(context);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MapsProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      drawer: const Drawerr(),
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.info_outlined),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),

        centerTitle: false,
        backgroundColor: Colors.red,
        title: const Text("Deprem Yardım"),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                context.read<MapsProvider>().afetzedeList.clear();
                context.read<MapsProvider>().markers.clear();
              });
              context.read<MapsProvider>().getAfetzedeList(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20,
              ),
              child: Icon(Icons.refresh,size: 30),
            ),
          )
        ],
      ),
      body: provider.currentPosition == null
          ? const Center(
        child: CircularProgressIndicator.adaptive(),
      )
          : GoogleMap(
        padding: const EdgeInsets.all(14),
        onTap: (argument) {
          selectedLat = argument.latitude;
          selectedLng = argument.longitude;
          _buildAddPinModal(context, selectedLat, selectedLng);
        },
        markers: Set<Marker>.of(provider.markers),
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        buildingsEnabled: true,
        initialCameraPosition: provider.currentPosition!,
        onMapCreated: (GoogleMapController controller) {
          provider.mapController.complete(controller);
        },
      ),

    );
  }

  Future<dynamic> _buildAddPinModal(BuildContext context, lat, lng) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enkaz altında bildirim formu',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Ad Soyad',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    subtitle: TextFormField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                      title: const Text(
                        'Afetzede',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: isAfetzede,
                                  onChanged: (value) {
                                    setState(() {
                                      isAfetzede = true;
                                      isNotAfetzede = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Ben',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: isNotAfetzede,
                                  onChanged: (value) {
                                    setState(() {
                                      isNotAfetzede = true;
                                      isAfetzede = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Bir yakınım',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'İletişim Numarası',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    subtitle: TextFormField(
                      controller: phoneNumberController,
                      focusNode: phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Açıklama',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    subtitle: TextFormField(
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      minLines: 5,
                      maxLines: 10,
                      decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      if (nameController.text.isEmpty) {
                        FocusScope.of(context).requestFocus(nameFocusNode);
                      } else if (phoneNumberController.text.isEmpty) {
                        FocusScope.of(context).requestFocus(phoneFocusNode);
                      } else if (descriptionController.text.isEmpty) {
                        FocusScope.of(context)
                            .requestFocus(descriptionFocusNode);
                      } else if (isAfetzede == false &&
                          isNotAfetzede == false) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const SizedBox(
                              height: 50,
                              child: Text(
                                'Lütfen afetzede seçin',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            actions: [
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      'Tamam',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      } else {
                        context.read<MapsProvider>().addAfetzede(
                            context,
                            nameController.text,
                            selectedLat,
                            selectedLng,
                            isAfetzede! ? '1' : '2',
                            phoneNumberController.text,
                            descriptionController.text);
                        nameController.clear();
                        selectedLat = null;
                        selectedLng = null;
                        isAfetzede = false;
                        isNotAfetzede = false;
                        phoneNumberController.clear();
                        descriptionController.clear();
                        Navigator.of(context).pop();
                        buildBottomSheet(context,
                            title: "Bilgileriniz Başarıyla Kaydedildi",
                            child: _successWidget());
                      }
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue,
                      ),
                      child: const Center(
                          child: Text(
                            'Afetzede Bildirimini Tamamla',
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
              ),
            ),
          ),
        );
      }),
    ).then(
          (value) {
        nameController.clear();
        selectedLat = null;
        selectedLng = null;
        isAfetzede = false;
        isNotAfetzede = false;
        phoneNumberController.clear();
        descriptionController.clear();
      },
    );
  }

  Widget _successWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 15),
        Container(
          child: const Icon(
            Icons.check,
            size: 50,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blue,
            ),
            child: const Center(
              child: Text(
                'Kapat',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}



class Drawerr extends StatelessWidget {
  const Drawerr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(

              decoration: const BoxDecoration(
                color: Colors.red,
              ),

              child: Stack(

                  children: const [
                    Positioned(
                      bottom: 8.0,
                      left: 4.0,
                      child: Text(
                        'Bilgi',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ]

              ),

            ),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: const Text('Hakkımızda'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    )
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.phone),
              title: const Text('İletişim'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ContactScreen(),
                    )
                );

              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.question_mark),
              title: const Text('Sıkça Sorulan Sorular'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HowToUseScreen(),
                    )
                );
              },
            ),
          ]
      ),
    );
  }
}
