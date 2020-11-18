import 'package:flutter/material.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';

class SolicitudesPendientesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(),
        ],
      ),
    );
  }
}