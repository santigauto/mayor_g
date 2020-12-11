import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';


class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario prefs = new PreferenciasUsuario();
    print(prefs.deviceId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          FutureBuilder(
            future: GetFriendsService().obtenerNotificaciones(context, dni: prefs.dni, deviceId: prefs.deviceId),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: (snapshot.data.length > 0)?snapshot.data.length: 1,
                  itemBuilder: (context,i){
                    if (snapshot.data.length > 0){
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey,)),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: ListTile(
                          title: Text('item $i'),
                        ));
                  } else return Container(height: MediaQuery.of(context).size.height * 0.8,child: Center(child: Text('No se han encontrado notificaciones',style: TextStyle(color:Colors.white),)),);
              }
              );}else return Center(child:CircularProgressIndicator());} )
        ],
      ),
    );
  }
}