import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voc_trainer/widgets/app_shell.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:voc_trainer/provider/settings_provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final supabaseUrl = dotenv.get('SUPABASE_URL');
  final anonKey = dotenv.get('SUPABASE_ANON_KEY');
  await Supabase.initialize(url: supabaseUrl, publishableKey: anonKey);

  // Web: supabase_flutter wertet den Login-Redirect selbst aus.
  if (!kIsWeb) {
    final initialUri = await AppLinks().getInitialLink();
    if (initialUri != null) {
      try {
        await supabase.auth.getSessionFromUrl(initialUri);
      } catch (_) {
        // Link enthielt keinen Auth-Code, ignorieren
      }
    }
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'VocTrainer',
  //     theme: ThemeData(primarySwatch: Colors.green),
  //     darkTheme: ThemeData(
  //       useMaterial3: true,
  //       brightness: Brightness.dark,
  //       colorScheme: const ColorScheme.dark(
  //         primary: Color(0xFF4CAF50),
  //         onPrimary: Colors.white,
  //         primaryContainer: Color(0xFF388E3C),
  //         onPrimaryContainer: Colors.white,
  //         secondary: Color(0xFF4CAF50),
  //         surface: Color(0xFF121212),
  //         onSurface: Colors.white,
  //         surfaceTint: Colors.transparent,
  //         surfaceContainer: Color(0xFF1E1E1E),
  //         surfaceContainerHigh: Color(0xFF2A2A2A),
  //       ),
  //     ),
  //     themeMode: ThemeMode.system,
  //     home: const AppShell(),
  //   );
  // }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(settingsProvider.select((s) => s.value?.darkMode ?? false));

    return MaterialApp(
      color: isDark ? const Color(0xFF121212) : Colors.white,
      debugShowCheckedModeBanner: false,

      title: 'VocTrainer',
      theme: ThemeData(primarySwatch: Colors.green),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4CAF50),
          onPrimary: Colors.white,
          primaryContainer: Color(0xFF388E3C),
          onPrimaryContainer: Colors.white,
          secondary: Color(0xFF4CAF50),
          surface: Color(0xFF121212),
          onSurface: Colors.white,
          surfaceTint: Colors.transparent,
          surfaceContainer: Color(0xFF1E1E1E),
          surfaceContainerHigh: Color(0xFF2A2A2A),
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const AppShell(),
    );
  }
}



//! Funktionalität
// https://claude.ai/chat/f16a70b3-7c5d-434c-a29b-1506e88b1cc7
// signupscreen und loginscreen zu authscreen 
// appshell neu
// auth provider signout 
// settings screen logout ändern

// manuelles navigieren nach login raus
// wordstateprovider ausgeloggt nicht beachten
// validierung bei allen textfields checken

// app shell sollte managen wo man ist

// settingssheet in eigenes file

//! Features
// drittes Feld für Aussprache
// nicht learned/ not sondern score
// immer Lernbündel
  // Die zentrale Methode, die einen Durchgang beginnt, und die Position im Bündel.
  // Balken und Titel auf das Bündel umstellen.
  // Dialog trennen: erst nur zeigen, dann die Wahl auswerten.
  // Wiederholen mit der Filterung nach Lernstatus aus dem Provider.
  // Sonderfälle: leeres Bündel, letztes Bündel, _first und _last.

  // "lernen" -> ein lernbündel von max 10 words herausnehmen, nach index gefiltert (die haben eh nach jedem initlearning einen index oder? nach dem kann man die ersten 10 zb nehmen)
  // dann werden diese durchgegangen
  // dann eine kurze übersicht wie mein end dialog von wegen, bündel wiederholen? abbrechen? nächstes bündel?
  // dann wird entweder zum nächsten bündel gesprungen (einfach _next) oder zum ersten wort des bündels 
  //  (falls showalreadylearned false ist dann auf das erste UNGELERNTE word im bundle
  // oder bundle geschafft
  // bitte schau über meinen plan drüber und strukturier das in einzelne punkte


// mehrere Sprachen gleichzeitig
// Auto Modus mit Audio