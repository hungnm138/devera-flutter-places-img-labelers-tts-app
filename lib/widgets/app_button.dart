import 'package:flutter/material.dart';

import '../widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final String? text;
  final IconData? icon;
  final double size;
  final Color borderColor;
  final bool? isIcon;

  const AppButton({
    Key? key,
    this.isIcon = false,
    this.text = 'Hi',
    this.icon,
    required this.size,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      child: isIcon == false
          ? Center(
              child: AppText(text: text!, color: color),
            )
          : Center(
              child: Icon(icon, color: color),
            ),
    );
  }
}
