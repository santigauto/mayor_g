import 'package:flutter/material.dart';

class AlertaOpcionesWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AlertaOpcionesWidget({this.title,this.children});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
    titlePadding: EdgeInsets.all(0),
    contentPadding: EdgeInsets.all(0),
    title: Container(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title:Center(child: Text(this.title,style: TextStyle(color: Colors.white),))
      ),
    ),
    content:ListView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: this.children
    )
  );
  }
}