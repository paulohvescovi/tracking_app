import 'package:flutter/material.dart';

class Text20 extends StatelessWidget {
  String text;
  TextAlign textAlign = TextAlign.center;

  Text20(this.text, {TextAlign textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(fontSize: 20.0, color: Colors.black87),
      textAlign: this.textAlign,
    );
  }
}
