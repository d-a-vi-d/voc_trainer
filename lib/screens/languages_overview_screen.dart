import 'package:flutter/material.dart';
import 'package:voc_trainer/services/word_service.dart';

class LanguagesOverviewScreen extends StatelessWidget {
  //final
  const LanguagesOverviewScreen();

  Widget _buildLanguagetile(int index) => Container(
    margin: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black, width: 3),
    ),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(10),
    child: Text(WordService.languages[index], style: TextStyle(fontSize: 20)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 8),
        title: Text("Language Overview"),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: SizedBox(
          height: 90,
          child: Column(
            children: <Widget>[
              for (
                int index = 0;
                index < WordService.languages.length;
                index += 1
              )
                Container(child: _buildLanguagetile(index)),
            ],
          ),
        ),
      ),
    );
  }
}
