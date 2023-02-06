import 'package:deprem_destek/components/screen/sub_screen_design.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return const BuildSubScreen(
      title: "İletişim",
      body:
          'Bize ulaşmak veya kötüye kullanım bildirmek için berkaypng@gmail.com adresini kullanabilirsiniz.\n\nKötüye kullanım olarak gönderdiğiniz pinler tarafımızdan kaldırılacaktır.',
    );
  }
}
