import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'star'    :  Icons.star,
  'collab'  :  Icons.markunread,
  'search'   :  Icons.search
};

Icon getIcon(String nombreIcono){
  return Icon(_icons[nombreIcono]);
}