import 'package:flutter/material.dart';
import 'package:voc_trainer/services/word_service.dart';
import 'package:voc_trainer/screens/home_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await WordService.loadWords();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voc Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}




// übersetzung nicht gleich sichtbar
// alles schöner machen