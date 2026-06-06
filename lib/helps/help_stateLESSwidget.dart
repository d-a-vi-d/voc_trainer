// ignore: file_names
import 'package:flutter/material.dart';

class CustomStatelesswidget extends StatelessWidget {
  const CustomStatelesswidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Übersicht")),
      body: const SafeArea(
        child: Padding(padding: EdgeInsets.all(15.0), child: Text("hallo")),
      ),
    );
  }
}
