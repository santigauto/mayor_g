import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class CollabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Collab')),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
          ],
        ),
      ),
    );
  }
}
