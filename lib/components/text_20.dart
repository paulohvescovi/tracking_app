import 'package:flutter/material.dart';

class Text20 extends StatelessWidget {
  String text;
  TextAlign textAlign = TextAlign.center;
  Color color = Colors.black87;
  bool negrito = false;

  Text20(this.text, {TextAlign this.textAlign, Color this.color, this.negrito});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
          fontSize: 20.0,
          color: this.color,
          fontWeight:
              negrito != null && negrito ? FontWeight.bold : FontWeight.normal),
      textAlign: this.textAlign,
    );
  }
}
