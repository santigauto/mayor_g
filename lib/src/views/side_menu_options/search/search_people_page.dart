import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
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
    if(_loading)
      return Center(child: CircularProgressIndicator(),);
    else if(_gente == null)
      return Center(
        child: Text('Realice una busqueda.',
          style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
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
          Card(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:12, vertical: 12),
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
                  MyTextInput('Dni', helper: 'Sin puntos ni comas.',
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
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: ListTile(
        onTap: () {},
        title: Text("${_gente[x].apellido} ${_gente[x].nombre}"),
        leading: Icon(Icons.face),
        trailing: FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          onPressed: () {
            /*...*/
            print(_gente[x].dni);
            GetFriendsService().enviarSolicitud(context, dni: prefs.dni, dniAmigo: _gente[x].dni);
          },
          child: Text("Invitar",),
        ),
      ),
    );
  }

  _submit() async {
    if(!_loading && _formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      /* PersonaServices personaServices = new PersonaServices();
      List<Persona> gente = await personaServices.getPersona(context,
        uat: await AuthService().getAccessToken(),
        dni: _dni,
        apellido: _apellido
      ); */
      List gente;
      if(_dni != null)gente = await GetFriendsService().obtenerUsuarioDni(context, dni: prefs.dni, deviceId: prefs.deviceId, dniBusqueda: _dni);
      else if(_apellido != null)gente = await GetFriendsService().obtenerUsuario(context, dni: prefs.dni, deviceId: prefs.deviceId, datos: _apellido);
      setState(() {
        _gente = gente;
        _loading = false;
      });
    }
  }
}