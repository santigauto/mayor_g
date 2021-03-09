import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Alert { 
  static void alert(BuildContext context, { Text title, @required Text body, List<Widget> actions, String dismissText = 'ok'  }) { 
    
    showDialog(context: context, builder: (context) {
      return (Platform.isAndroid)
        ?AlertDialog(
          title: title,
          content: body,
          actions: (actions == null)
            ?[
            MaterialButton(
              child: Text(dismissText),
              onPressed: ()=>Navigator.pop(context),)
            ]
            :actions
        )
        :CupertinoAlertDialog(
          title: title,
          content: body,
          actions: (actions == null)
            ?[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                 },
                child: Text(dismissText),
              )
            ]
            :actions
        );
    });
  }
}