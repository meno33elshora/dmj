import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String txt;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? colorText;
  final double? sizeText;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.txt,
    this.borderColor = Colors.transparent,
    required this.backgroundColor,
    this.colorText,
    this.sizeText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shadowColor: Colors.transparent,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: borderColor!))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            txt,
            style: TextStyle(
              fontSize: sizeText ?? 15,
              color: colorText ?? Colors.white,
            ),
            // notFontFamily: false,
          ),
        ),
      ),
    );
  }
}
