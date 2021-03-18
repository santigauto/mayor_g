

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

class DeviceInfoService{

  PreferenciasUsuario prefs = PreferenciasUsuario();

    //----------------------------- OBTENER DEVICE INFO -------------------------------

   Future getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.sdkInt.toString();
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    prefs.deviceId =  identifier;
    prefs.deviceVersion = deviceVersion.toString();
    prefs.deviceName  = deviceName;
//if (!mounted) return;
return identifier/* [deviceName, deviceVersion, identifier] */;
}
}