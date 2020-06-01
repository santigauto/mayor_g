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
    return Theme(
      data: new ThemeData(
        primaryColor: Colors.white70,
        hintColor: Colors.white70,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white,),
        )
      ),
      child: TextFormField(
        keyboardType: textInputType,
        maxLength: maxLenght,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
        ),
        validator: validator,
      ),
    );
  }
}