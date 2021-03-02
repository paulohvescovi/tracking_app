import 'package:flutter/material.dart';

class ButtonGrande extends StatelessWidget {
  String label;
  Function onPressed;

  ButtonGrande(this.label, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 60,
      child: RaisedButton(
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            this.onPressed();
          }),
    );
  }
}
