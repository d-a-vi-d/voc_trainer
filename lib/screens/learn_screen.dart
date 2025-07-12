import 'package:flutter/material.dart';
import 'package:voc_trainer/screens/learn_mode_screen.dart';
import 'voc_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  // statisch für jetzt
  final List<String> languages = const ['Englisch', 'Spanisch', 'Thai'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lernen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: languages.map((language) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LearnModeScreen(language: language),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(double.infinity, 80),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school, size: 24), 
                        const SizedBox(height: 4),
                        Text(
                          language,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            ).toList(),
          ),
        ),
      ),
    );
  }
}
