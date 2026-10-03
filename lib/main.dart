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
// signupscreen und loginscreen überarbeiten glaub ist unclean
// validierung
// supabase.auth in den provider
// app shell sollte managen wo man ist
// mehrzeiligen text im learnmode zentrieren

//! Features
// Marker für Wörter (!)
// notizen je sprache
// drittes Feld für Aussprache

// immer Lernbündel
// mehrere Sprachen gleichzeitig
// Auto Modus mit Audio
// offline/ online sync