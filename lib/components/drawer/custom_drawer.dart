import 'package:deprem_destek/screens/sub/about_screen.dart';
import 'package:deprem_destek/screens/sub/contact_screen.dart';
import 'package:deprem_destek/screens/sub/sss_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
              child: Stack(children: const [
                Positioned(
                  bottom: 8.0,
                  left: 4.0,
                  child: Text(
                    'Bilgi',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
              ]),
            ),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: const Text('Hakkımızda'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ));
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.phone),
              title: const Text('İletişim'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactScreen(),
                ));
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.question_mark),
              title: const Text('Sıkça Sorulan Sorular'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HowToUseScreen(),
                ));
              },
            ),
          ]),
    );
  }
}
