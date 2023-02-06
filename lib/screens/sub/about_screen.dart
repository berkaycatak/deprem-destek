import 'package:deprem_destek/components/screen/sub_screen_design.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return BuildSubScreen(
      title: "Hakkımızda",
      body:
          'Deprem Yardım enkaz altındaki vatandaşlara ulaşımı kolaylaştırmak amacıyla oluşturulmuş bir sosyal sorumluluk projesidir ve hiçbir gelir beklentisi yoktur.',
    );
  }
}
