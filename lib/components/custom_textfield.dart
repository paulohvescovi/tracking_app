import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool enabled;
  final TextEditingController controller;
  final bool visibility;
  final Icon icon;
  final bool autoPadding;

  const CustomTextField(
      {Key key,
      this.hintText,
      this.labelText,
      this.enabled,
      this.controller,
      this.visibility,
      this.icon,
      this.autoPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.visibility != null ? visibility : true,
      child: Padding(
        padding: this.autoPadding == null || this.autoPadding
            ? EdgeInsets.only(top: 8)
            : EdgeInsets.only(top: 0),
        child: Container(
          width: double.infinity,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: this.icon,
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
            enabled: enabled,
          ),
        ),
      ),
    );
  }
}
