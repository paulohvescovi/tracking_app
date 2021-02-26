
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {

  final String label;
  final bool value;
  final Function onchange;

  CustomSwitch({
    this.label,
    this.value,
    this.onchange
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Text(label),
        ),
        Switch(
          value: value,
          onChanged: onchange,
        )
      ],
    );
  }
}
