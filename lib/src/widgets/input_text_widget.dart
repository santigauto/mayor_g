
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
  bool ocultarPassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: widget.color),
      keyboardType: widget.inputType,
      obscureText: widget.password ? ocultarPassword : false,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: widget.inputIcon != null ? widget.inputIcon : null,
        errorStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.color),
        suffixIcon: !widget.password ? null :
          IconButton(
            color: Colors.white,
            icon: Icon(ocultarPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => ocultarPassword = !ocultarPassword)
          ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.color
          )
        )
      ),
    );
  }
}