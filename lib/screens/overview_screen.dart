import 'package:flutter/material.dart';
import 'voc_screen.dart'; 

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<String> languages = ['Englisch', 'Spanisch', 'Thai'];
  final TextEditingController _controller = TextEditingController();

  void _addLanguage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      languages.add(_controller.text.trim());
      _controller.clear();
    });
  }

  void _removeLanguage(int index) {
    setState(() {
      languages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Übersicht & Sprachen')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Neue Sprache',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addLanguage,
                  child: const Text('Hinzufügen'),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 Buttons nebeneinander
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3, // Button etwas breiter
              ),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VocScreen(language: language),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    language,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
