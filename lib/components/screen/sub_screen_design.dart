import 'package:flutter/material.dart';

class BuildSubScreen extends StatefulWidget {
  final String title;
  final String body;
  const BuildSubScreen({super.key, required this.title, required this.body});

  @override
  State<BuildSubScreen> createState() => BuildSubScreenState();
}

class BuildSubScreenState extends State<BuildSubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.red,
        title: const Text("Deprem Yardım"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    SelectableText(
                      widget.body,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
