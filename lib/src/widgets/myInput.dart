import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  final Function validator;
  final String label;
  MyInput({Key key, this.validator, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
        child: TextFormField(
          cursorColor: Colors.grey[700],
          validator: validator,
          maxLength: 100,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color:Colors.grey
            )
          ),
        ),
      ),
    );
  }
}