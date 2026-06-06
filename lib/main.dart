import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/widgets/app_shell.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/word_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await WordService.load();
  await dotenv.load();
  final supabaseUrl = dotenv.get('SUPABASE_URL');
  final anonKey = dotenv.get('SUPABASE_ANON_KEY');
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  //TODO wofür würde ich applinks brauchen?
  final appLinks = AppLinks();

  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null) {
    await supabase.auth.getSessionFromUrl(initialUri);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vokabeltrainer',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AppShell(),
    );
  }
}



//! Funktionalität
// riverpod implementieren
  // onAuthStateChange managen statt navigator.pushReplacement
// Settings wo speichern
// mit supabase verknüpfen

//! Features
// drittes Feld für Aussprache
// Marker für Wörter (!)
// immer Lernbündel
// mehrere Sprachen gleichzeitig
// Auto Modus mit Audio


// ✔️renaming a language - checking the check in the appbar - new language name not saved