import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';

class ProfilePage extends StatelessWidget {
  final Persona persona;
  final bool isPersonal;
  ProfilePage({this.isPersonal,this.persona});



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    PreferenciasUsuario prefs = new PreferenciasUsuario();
    Persona p = new Persona();
    if (isPersonal){
      p.apellido = prefs.apellido;
      p.nombre = prefs.nombre;
      p.dni = prefs.dni;
      p.nickname = prefs.nickname;
    } else p = this.persona;

    return Stack(
      children: [
        BackgroundWidget(),
        Container(
          color: Theme.of(context).primaryColor,
          width: double.infinity,
          height: size.height * 0.25,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(p.nickname, style: Theme.of(context).textTheme.headline4,)
              ],
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.15,
            left: size.width * 0.5 - size.height * 0.1,
            child: CircleAvatar(
              radius: size.height * 0.1,
              backgroundColor: Colors.white,
              child: Text(p.nombre[0].toUpperCase(), style: TextStyle(color: Colors.black),),
            )
        ),
      ],
    );
  }
}
