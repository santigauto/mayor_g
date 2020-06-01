import 'package:flutter/material.dart';
import 'package:mayor_g/models/persona_model.dart';
import 'package:mayor_g/services/auth_service.dart';
import 'package:mayor_g/services/commons/personas.dart';
import 'package:mayor_g/widgets/MyTextInput.dart';
import 'package:mayor_g/widgets/MyImagen.dart';
import 'package:mayor_g/widgets/background_widget.dart';


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

  List<Persona> _gente;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            ListView(
              children: <Widget>[
                createCardBuscar(context),
                SizedBox(height: 24,),
                Expanded(
                  child: createList()
                ),
              ],
            )
          ],
        ),
        /* floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child:Icon(Icons.search), 
          onPressed: (){showSearch(context: context, delegate: DataSearch(_gente));}) */
        /* floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child:Icon(Icons.search), 
          onPressed: (){}
        ) */
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
    else if(_gente[0].dni == 0 || _gente[0].dni == null)
      return Center(
        child: Text(_gente[0].mensaje,
          style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        )
      );
    else
      return ListView.builder(
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
                  SizedBox(height: 12.0,),
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
        title: Text("${_gente[x].grado} ${_gente[x].apellido} ${_gente[x].nombres}"),
        leading: MyImage(imageBytes: _gente[x].foto,),
        trailing: FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          onPressed: () {
            /*...*/
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

      PersonaServices personaServices = new PersonaServices();
      List<Persona> gente = await personaServices.getPersona(context,
        uat: await AuthService().getAccessToken(),
        dni: _dni,
        apellido: _apellido
      );

      setState(() {
        _gente = gente;
        _loading = false;
      });
    }
  }
}