// ignore: file_names
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Übersicht")),
      body: const SafeArea(
        child: Padding(padding: EdgeInsets.all(15.0), child: Text("body")),
      ),
    );
  }
}
