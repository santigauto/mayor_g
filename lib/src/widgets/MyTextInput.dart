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
        primaryColor:Theme.of(context).primaryColor,
        hintColor: Theme.of(context).primaryColor,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Theme.of(context).primaryColor,),
        )
      ),
      child: TextFormField(
        keyboardType: textInputType,
        maxLength: maxLenght,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
        ),
        validator: validator,
      ),
    );
  }
}