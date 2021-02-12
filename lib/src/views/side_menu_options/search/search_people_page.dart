import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/friends/friend_selector_service.dart';
import 'package:mayor_g/src/services/user/user_service.dart';
import 'package:mayor_g/src/widgets/MyTextInput.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';


class BlocSearch{
  final StreamController _streamController = new StreamController.broadcast();

  Function get searchSink => _streamController.sink.add;

  Stream get searchStream => _streamController.stream;

  void disposeStream() { 
    _streamController?.close();
  }
}


class SearchPeoplePage extends StatefulWidget {
  SearchPeoplePage({Key key}) : super(key: key);

  @override
  _SearchPeoplePageState createState() => _SearchPeoplePageState();
}

class _SearchPeoplePageState extends State<SearchPeoplePage> {
  /* List<Map<String,dynamic>> gente = [
    {'nombre': 'Mara'  ,'grado':'VP'}, 
    {'nombre':'Esteban','grado':'CT'}, 
    {'nombre': 'Juan'  ,'grado':'SP'}, 
    {'nombre': 'Roger' ,'grado':'TC'}, 
    {'nombre':'Rodrigo','grado':'CI'}]; */
  final _formKey = GlobalKey<FormState>();
  String _apellido = '';
  int _dni;
  bool _loading = false;
  PreferenciasUsuario prefs = new PreferenciasUsuario();

  List<Persona> _gente;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          ListView(
            children: <Widget>[
              createCardBuscar(context),
              SizedBox(height: 24,),
              createList(),
            ],
          )
        ],
      ),
    );

  }

  Widget createList(){
    print(_gente.toString());
    if(_loading)
      return Center(child: CircularProgressIndicator(),);
    else if(_gente == null)
      return Center(
        child: Text('Realice una busqueda.',
          style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    else if(_gente.length == 0) return Center(child: Text("No se han encontrado coincidencias",style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20),));
    else
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _gente.length,
        itemBuilder: (context, x) => _listItem(x),
      );
  }

  Form createCardBuscar(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
              color: Colors.white,
            ),
              padding: const EdgeInsets.only(left:12,right: 12, bottom: 12),
              child: Column(
                children: <Widget>[
                  MyTextInput('Apellido', helper: 'Ingrese el apellido completo.',
                    validator: (String text) {
                      if(text.length < 3 && text.length > 0)
                        return 'Ingrese como mínimo 3 caracteres.';
                      _apellido = text;
                      return null;
                    }
                  ),
                  SizedBox(height: 8.0,),
                  MyTextInput('DNI', helper: 'Sin puntos ni comas.',
                    textInputType: TextInputType.number,
                    validator: (String text) {
                      if(text.isNotEmpty)
                        _dni = int.parse(text);
                      else
                        _dni = null;
                      return null;
                    }
                  ),
                ],
              ),
          ),
          SizedBox(height: 8.0,),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text('Buscar', style: TextStyle(color: Colors.white),),
            onPressed: _submit
          ),
        ],
      ),
    );
  }
  
  Widget _listItem(int x){
    return(_gente[0].apellido != null)? Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: ListTile(
        onTap: () {},
        title: Text('${_gente[x].nickname}'),
        leading: Icon(Icons.face),
        trailing: FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          onPressed: () {
            /*...*/
            print(_gente[x].dni);
            GetFriendsService().enviarSolicitud(context, dni: prefs.dni, dniAmigo: _gente[x].dni, deviceId: prefs.deviceId);
          },
          child: Text("Invitar",),
        ),
      ),
    )
    : ListTile(
      title: Text("No se encontraron coincidencias"),
    );
  }

  _submit() async {
    if(!_loading && _formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      List<Persona> gente = [];
      if(_dni != null){
        Persona p = await GetUserService().obtenerUsuarioDni(context, dni: prefs.dni, deviceId: prefs.deviceId, dniBusqueda: _dni);
        print(p.toString());
        if(p!=null)gente.add(p);
      }
      else if(_apellido != null){
        List<Persona> lp = await GetUserService().obtenerUsuario(context, dni: prefs.dni, deviceId: prefs.deviceId, datos: _apellido);
        if(lp!=[])gente.addAll(lp);
      }
      setState(() {
        print(gente);
        _gente = gente;
        _loading = false;
      });
    }
  }
}