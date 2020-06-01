import 'package:flutter/material.dart';

class MyTextInput extends StatelessWidget {
  final String label;
  final String helper;
  final TextInputType textInputType;
  final int maxLenght;
  final Function(String) validator;

  MyTextInput(
    this.label, {
    Key key,
    this.helper = '',
    this.textInputType = TextInputType.text,
    this.maxLenght,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      maxLength: maxLenght,
      decoration: InputDecoration(
        focusColor: Colors.red,
        hoverColor: Colors.red,
        fillColor: Colors.red,
        labelText: label,
        helperText: helper
      ),
      validator: validator,
    );
  }
}