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
            _drawerProfile(),
            Container(child: _lista(), color: Colors.white.withOpacity(0.7),),
            Expanded(child: Container(color: Colors.white.withOpacity(0.7),)),
            Container(
              color: Colors.brown[200],
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.red[400],
                ),
                title: Text('Log Out', style: TextStyle(color: Colors.red[400])),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red[400]),
                onTap: (){AuthService().logout(context: context);},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawerProfile() {

    return Container(
      height: 152,
      color: Colors.green[900],
      child: DrawerHeader(
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
                  backgroundImage: imagen(),
                  backgroundColor: Colors.yellow,
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
                  icon: Icon(Icons.settings),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider imagen(){
    if(prefs.foto == null || prefs.foto == 'null'){
      return AssetImage('assets/harold.jpeg');
    }else return NetworkImage(prefs.foto);
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
