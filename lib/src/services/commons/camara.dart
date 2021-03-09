import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Camara{
  getImage(BuildContext context) async {
    ImageSource source = ImageSource.gallery;
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 92,
          maxWidth: 900,
          maxHeight: 900,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).primaryColor,
            toolbarTitle: "Recortar imagen",
            backgroundColor: Colors.white,
          )
      );

      if(cropped != null){
        final bytes = await cropped.readAsBytes();
        return base64Encode(bytes);
      }
    }

    return null;
  }
}
