import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  Function validator;
  String label;
  MyInput({Key key, this.validator, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Colors.white.withOpacity(0.6),
        child: TextFormField(
          validator: validator,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      ),
    );
  }
}