import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/services/auth_service.dart';
import 'package:mayor_g/services/commons/drawer_service.dart';
import 'package:mayor_g/utils/icon_string_util.dart';

class SideMenuWidget extends StatelessWidget {
  SideMenuWidget({Key key}) : super(key: key);
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            _drawerProfile(context),
            Container(child: _lista(), color: Colors.white.withOpacity(0.7),),
            Expanded(child: Container(color: Colors.white.withOpacity(0.7),)),
            Container(
              color: Theme.of(context).primaryColor,
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                title: Text('Log Out', style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){AuthService().logout(context: context);},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawerProfile(BuildContext context) {

    return Container(
      height: 152,
      color: Colors.white.withOpacity(0.7),
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 32,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/mayorG@3x.png'))),
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 27,
                  backgroundImage: imagen(),
                  backgroundColor: Color(0xFF838547),
                ),
                SizedBox(width: 7,),
                Column(
                  //nombre de usuario
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      prefs.apellido,
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                    Text(
                      prefs.nombre,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )
                  ],
                ),
                Expanded(child: Container()),
                IconButton(
                  onPressed: () {
                    print(prefs.foto);
                  },
                  icon: Icon(Icons.settings, color: Colors.white,),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider imagen(){// Hacerla GLOBAL!!
    if(prefs.foto == null || prefs.foto == 'null'){
      return AssetImage('assets/soldier.png');
    }else return MemoryImage(
      base64Decode(prefs.foto),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Column(children: _crearItems(snapshot.data, context));
      },
    );
  }

  List<Widget> _crearItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    data.forEach((item) {
      final widgetTemp = ListTile(
        title: Text(item['texto']),
        leading: getIcon(item['icon']),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.popAndPushNamed(context, item['ruta']);
        },
      );
      opciones..add(widgetTemp);
    });

    return opciones;
  }
}
