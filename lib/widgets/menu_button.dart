import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool selected;
  final String text;

  const MenuButton({
    super.key,
    this.onTap,
    this.selected = false,
    this.text = "nix",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 3),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
