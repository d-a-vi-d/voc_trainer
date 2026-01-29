import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/word_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WordService.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vokabeltrainer',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

// ✅sprachen overview screen
// ✔️renaming a language - checking the check in the appbar - new language name not saved
// ✅which language first - nothing is green
// state management (wann wörter updaten - zb "sterne exkludieren")
  // always foreign language when going into learning mode - should regard the settings (shared_preferences)
  // is aber geil wenn man das letzte wort noch da hat
// supabase + login
// ✅cycle managen (progress bar zeigt an wo im cycle man ist, "durchgang fertig - neu beginnen?")
// Suchfunktion
// ✅"Übersicht" Button so machen wie Pfeil zurück Button