import 'dart:convert';

import 'package:flutter/material.dart';

class ImagenPerfil extends StatelessWidget {
  final String photoData;
  final double radius;
  const ImagenPerfil({Key key, this.photoData, this.radius}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: _imagen(photoData),
      backgroundColor: Color(0xFF838547),
      radius: radius,
    );
  }

ImageProvider _imagen(photoData){

try{
      if(photoData == null || photoData == 'null' || photoData == ''){
    return AssetImage('assets/soldier.png');
  }else return MemoryImage(
    base64Decode(photoData),
  );
    }catch (e){
      print(e.toString());
    }
      return AssetImage('assets/soldier.png');
  }

}