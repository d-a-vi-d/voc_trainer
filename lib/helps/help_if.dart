import 'package:flutter/material.dart';

final number = 1;
final hello = number == 1
    ? [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))]
    : number == 2
    ? [IconButton(onPressed: () {}, icon: const Icon(Icons.close))]
    : null;

bool? hi() {
  if (number == 1) {
    return true;
  } else if (number == 2) {
    return false;
  }
  return null;
}
