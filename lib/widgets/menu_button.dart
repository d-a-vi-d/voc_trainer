import 'package:flutter/material.dart';
import 'package:voc_trainer/utils/app_colors.dart';

class MenuButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool selected;
  final String text;

  const MenuButton({super.key, this.onTap, this.selected = false, this.text = "nix"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.tileBackground(context, selected: selected),
          borderRadius: BorderRadius.circular(15),
          border: AppColors.tileBorder(context),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
      ),
    );
  }
}
