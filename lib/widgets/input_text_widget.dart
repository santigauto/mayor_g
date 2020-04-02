
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {

  final String label;
  final bool password;
  final Color color;
  final TextInputType inputType;
  final Function validator;
  final Icon inputIcon;

  const TextInput({Key key, this.label, this.password = false, this.color, this.inputType, this.validator, this.inputIcon}) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: widget.color),
      keyboardType: widget.inputType,
      obscureText: widget.password,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: widget.inputIcon != null ? widget.inputIcon : null,
        errorStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.color),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.color
          )
        )
      ),
    );
  }
}