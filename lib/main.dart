import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/widgets/app_shell.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final supabaseUrl = dotenv.get('SUPABASE_URL');
  final anonKey = dotenv.get('SUPABASE_ANON_KEY');
  await Supabase.initialize(url: supabaseUrl, publishableKey: anonKey);

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vokabeltrainer',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AppShell(),
    );
  }
}



//! Funktionalität
// signupscreen und loginscreen überarbeiten glaub ist unclean
// validierung
// supabase.auth in den provider
// app shell sollte managen wo man ist

// "backup erfolgreich erstellt"

//! Features
// drittes Feld für Aussprache
// Marker für Wörter (!)
// immer Lernbündel
// mehrere Sprachen gleichzeitig
// Auto Modus mit Audio
// offline/ online sync