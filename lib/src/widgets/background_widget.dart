import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background_myg.jpeg'), 
                  fit: BoxFit.fill)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image:DecorationImage(
              image: AssetImage('assets/bgCopia6@2x.png'), 
              fit: BoxFit.fill)
          ),
        )
      ],
    );
  }
}

