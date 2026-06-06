import 'package:flutter/material.dart';

Widget _buildContainer({required Widget child}) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
    child: const Column(
      children: [
        Row(children: [Text("1"), Text("Es ist okay...")]),
        Row(
          children: [
            Column(children: [Text("papa"), Text("nein")]),
            Column(children: [Text("mama"), Text("nein")]),
          ],
        ),
      ],
    ),
  );
}

final hello = TextButton(
  child: const Text("hi"),
  onPressed: () {
    _buildContainer(child: const Text(""));
  },
);
