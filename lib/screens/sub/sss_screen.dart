import 'package:deprem_destek/components/screen/sub_screen_design.dart';
import 'package:flutter/material.dart';

class HowToUseScreen extends StatefulWidget {
  const HowToUseScreen({super.key});

  @override
  State<HowToUseScreen> createState() => _HowToUseScreenState();
}

class _HowToUseScreenState extends State<HowToUseScreen> {
  @override
  Widget build(BuildContext context) {
    return const BuildSubScreen(
      title: "Nasıl Kullanılır?",
      body:
          '1- Depremzede Nasıl Eklenir?\n\nDeprem Yardım uygulamasına depremzede eklemek için harita üzerinde bir noktaya dokunun. Karşınıza çıkan formu doldurduktan sonra "Afetzede Bildirimini Tamamla" butonuna tıklatın.\n\n\n2- Nasıl kurtarıldı işaretlenir?\n\nKurtarıldı olarak işaretlemek istediğiniz pinin üzerine tıklatın. Karşınıza çıkan bilgi ekranının en altında bulunan "kurtarıldı" butonuna tıklatın. Karşınıza çıkan uyarıda onay verin.',
    );
  }
}
