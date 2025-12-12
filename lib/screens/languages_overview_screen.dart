import 'package:flutter/material.dart';

class LanguagesOverviewScreen extends StatelessWidget {
  //final
  const LanguagesOverviewScreen();

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (hallo, hall) {},
      children: [
        Text(key: ValueKey(1), "hallo"),
        Text(key: ValueKey(2), "hi"),
      ],
    );
  }
}
