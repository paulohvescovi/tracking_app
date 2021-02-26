
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String hintText;
  final String labelText;
  final bool enabled;
  final TextEditingController controller;

  const CustomTextField({
    Key key,
    this.hintText,
    this.labelText,
    this.enabled,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        enabled: enabled,
      ),
    );
  }
}
