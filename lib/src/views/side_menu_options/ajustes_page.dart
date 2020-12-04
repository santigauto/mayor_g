import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
import 'package:mayor_g/src/services/filterServices/arma_service.dart';
import 'package:mayor_g/src/services/filterServices/curso_service.dart';
import 'package:mayor_g/src/services/filterServices/materia_service.dart';
import 'package:mayor_g/src/services/filterServices/organismo_service.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/input_text_widget.dart';
import 'package:mayor_g/src/widgets/loading_widget.dart';

class AjustesPartidaPage extends StatefulWidget {
  @override
  _AjustesPartidaPageState createState() => _AjustesPartidaPageState();
}

class _AjustesPartidaPageState extends State<AjustesPartidaPage> {
  final _formKey = GlobalKey<FormState>();
  final player = BackgroundMusic.backgroundAudioPlayer;
  final prefs = new PreferenciasUsuario();
  String selectedArma;
  String selectedMateria;
  String selectedColegio;
  String selectedCurso;
  String nickNuevo;

  String auxArma;
  String auxMateria;
  String auxColegio;
  String auxCurso;
  double aux = 0.0;

  bool _isLoading = false;

  @override
  void initState() {
    auxArma = prefs.arma;
    auxMateria = prefs.materia;
    auxColegio = prefs.colegio;
    auxCurso = prefs.curso;
    super.initState();
  }

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        await GetFriendsService().cambiarNick(context, dni: prefs.dni, deviceId: prefs.deviceId, nickname: nickNuevo).then((value) {
          if(value)prefs.nickname = nickNuevo;
        });

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(prefs.nickname);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                SafeArea(child: Container()),
                //NICKNAME
                ExpansionTile(

                  subtitle: Row(
                      children: [
                        Text(
                          'Aquí puede modificar su Nickname',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  title: Row(
                    children: [
                      Text(
                        'Usuario',
                        style: TextStyle(
                            fontSize:30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: TextInput(
                          label:(prefs.nickname == null)?"Actual: " + prefs.nombre + " "+prefs.apellido : prefs.nickname,
                          inputIcon: Icon(Icons.edit,color: Colors.white,),
                          color: Colors.white,
                          validator: (String text) {
                            if (text.isEmpty) {
                              return 'Por favor completar el campo';
                            }
                            nickNuevo = text;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
                Divider(color: Colors.white.withOpacity(0.2)),
                //FILTROS
                ExpansionTile(
                  title: Row(
                           children: <Widget>[
                      Text(
                        'Filtros',
                        style: TextStyle(
                            fontSize:
                                30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  subtitle: Text(
                  'Filtre a su criterio las características de las preguntas',
                  style: TextStyle(color: Colors.white),
                ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _opciones(size),
                    ),
                  ],
                ),
                
                Divider(color: Colors.white.withOpacity(0.2)),
                //SONIDOS
                ExpansionTile(
                  title: Row(
                    children: [
                      Text(
                        'Sonido',
                        style: TextStyle(
                            fontSize:30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  children: [
                    StreamBuilder<double>(
                      stream: player.volumeStream,
                      builder: (context, snapshot) {
                        return Container(
                          padding: EdgeInsets.all(10.0),
                        height: 100.0,
                        child: Row(
                          children: [
                            IconButton(icon: (snapshot.data != 0)?Icon((snapshot.data <=0.5)?Icons.volume_down:Icons.volume_up,color:Colors.white):Icon(Icons.volume_off),
                              onPressed:(){
                                if(snapshot.data != 0.0){
                                  aux = snapshot.data;
                                  print(aux.toString());
                                  player.setVolume(0.0);
                                }else{
                                  print(aux.toString());
                                  player.setVolume(aux);
                                }
                              }  
                            ),
                            Expanded(
                              child: Slider(
                                divisions: 100,
                                min: 0.0,
                                max: 1.0,
                                value: snapshot.data ?? 1.0,
                                onChanged: player.setVolume,
                              ),
                            ),
                            Text('${(snapshot.data*100).toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.white,
                                fontFamily: 'Fixed',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0)),
                          ],
                        ),
                      );
                      }
                    ),
                  ],
                ),
                
                Divider(color: Colors.white.withOpacity(0.2)),

                Container(height: 300,)
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: size.width*0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: AutoSizeText("Restablecer",maxLines: 1, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            onTap: () {
                              prefs.arma = auxArma;
                              prefs.materia = auxMateria;
                              prefs.colegio = auxColegio;
                              prefs.curso = auxCurso;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width*0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: AutoSizeText("Guardar",maxLines: 1, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            onTap: () {
                              _submit();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          (_isLoading)
              ? LoadingWidget(
                  caption: Text('Buscando preguntas, aguarde...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _opciones(Size size) {
    return Column(
      children: <Widget>[
        _getDropdown(
          size: size,
          title: 'Organismo',
          jsonFrac: 'colegios',
          selectedValues: selectedColegio,
          hint: prefs.colegio,
          future: OrganismoService().getAll(context, 'organismo'),
          onChanged: (value) {
            setState(() {
              selectedColegio = value;
              prefs.colegio = value;
            });
          },
        ),
        _getDropdown(
          size: size,
          title: 'Arma',
          jsonFrac: 'armas',
          selectedValues: selectedArma,
          hint: prefs.arma,
          future: ArmaService().getAll(context, 'arma'),
          onChanged: (value) {
            setState(() {
              selectedArma = value;
              prefs.arma = value;
            });
          },
        ),
        _getDropdown(
          size: size,
          title: 'Curso',
          jsonFrac: 'cursos',
          selectedValues: selectedCurso,
          hint: prefs.curso,
          future: CursoService().getAll(context, 'curso'),
          onChanged: (value) {
            setState(() {
              selectedCurso = value;
              prefs.curso = value;
            });
          },
        ),
        _getDropdown(
          size: size,
          title: 'Materia',
          jsonFrac: 'materias',
          selectedValues: selectedMateria,
          hint: prefs.materia,
          future: Materia2Service().getAll(context, 'materia'),
          onChanged: (value) {
            setState(() {
              selectedMateria = value;
              prefs.materia = value;
            });
          },
        ),
        Divider(color: Colors.white.withOpacity(0.2)),
      ],
    );
  }

  Widget _getDropdown(
      {String title,
      String jsonFrac,
      Function onChanged,
      Size size,
      String selectedValues,
      String hint,
      Future future}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          right: BorderSide(
                              color: Colors.black.withOpacity(0.4)))),
                  child: Center(
                      child: AutoSizeText(title,
                          maxLines: 1,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                              fontWeight: FontWeight.bold)))),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButton(
                            style: TextStyle(color: Colors.white,),
                            iconEnabledColor: Colors.white,
                            hint: Container(
                              width: size.width * 0.55,
                              child: DropdownMenuItem(
                                  child: Center(
                                    child: AutoSizeText(
                                hint,
                                maxLines: 2,
                                style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                                  )),
                            ),
                            underline: Container(),
                            dropdownColor: Theme.of(context).primaryColor,
                            value: selectedValues,
                            items: getItems(snapshot.data, hint),
                            onChanged: onChanged);
                      } else
                        return CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getItems(List data, String hint) {
    List<DropdownMenuItem<String>> lista = new List();

    if (data.isNotEmpty) {
      data.forEach((item) {
        lista.add(DropdownMenuItem(
            value: item.nombre,
            child: Center(
                child: Container(
                    width: 200,
                    child: AutoSizeText(
                      item.nombre,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6.fontSize),
                      textAlign: TextAlign.center,
                    )))));
      });
    }
    return lista;
  }
}
