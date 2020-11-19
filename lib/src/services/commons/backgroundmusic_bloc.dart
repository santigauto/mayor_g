//import 'package:flutter/material.dart';

import 'dart:async';

class BackgroundMusicBloc{
  StreamController _streamController = new StreamController<String>.broadcast();

  Stream<String> get backgroudMusicStream => _streamController.stream;
  Function(String) get backgroundMusicSink => _streamController.sink.add;

  void dipose(){
    _streamController?.close();
  }
}