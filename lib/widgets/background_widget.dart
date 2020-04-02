import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background_myg.jpeg'), fit: BoxFit.fill)),
  );
  }
}

