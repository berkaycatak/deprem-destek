import 'package:deprem_destek/providers/maps_provider.dart';
import 'package:deprem_destek/screens/maps/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapsProvider()),
      ],
      child: MaterialApp(
        title: 'Deprem Destek',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapScreen(),
      ),
    );
  }
}
