import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/services/commons/camara.dart';
import 'package:mayor_g/src/services/filters/arma_service.dart';
import 'package:mayor_g/src/services/filters/curso_service.dart';
import 'package:mayor_g/src/services/filters/materia_service.dart';
import 'package:mayor_g/src/services/filters/organismo_service.dart';
import 'package:mayor_g/src/services/user/user_service.dart';
import 'package:mayor_g/src/widgets/alert_opciones_widget.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/imagen_perfil.dart';
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
  String imagen;
  Camara camaraController = new Camara();

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

        if (nickNuevo.isNotEmpty)
          await GetUserService()
              .cambiarNick(context,
                  dni: prefs.dni, deviceId: prefs.deviceId, nickname: nickNuevo)
              .then((value) {
            if (value) prefs.nickname = nickNuevo;
          });
        if (imagen.isNotEmpty){
          imagen = imagen.replaceFirst('data:image/jpeg;base64,', '');
          if(imagen.length < 2){imagen = '';}
        bool validado = false;
          validado = await GetUserService().cambiarFoto(context,
              dni: prefs.dni, deviceId: prefs.deviceId, imagen: imagen).then((value){ if(validado){
                prefs.foto = imagen;
              }
              return true;
              });
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = ModalRoute.of(context).settings.arguments;
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
            padding: const EdgeInsets.symmetric(horizontal:5.0),
            child: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                SafeArea(child: Container()),
                //NICKNAME
                (routeData['logueado'])?ExpansionTile(
                  subtitle: Text(
                    'Aquí puede modificar su Nickname y foto de perfil',
                    style: TextStyle(color: Colors.white),
                  ),
                  title: Row(
                    children: [
                      Text(
                        'Usuario',
                        style: TextStyle(
                            fontSize: 30,
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
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ImagenPerfil(photoData: (imagen != null)?imagen:prefs.foto,radius: size.width * 0.1,),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: size.width*0.05,
                                    backgroundColor:
                                        Theme.of(context).primaryColor.withOpacity(0.7),
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: uploadImage,
                                      color: Colors.white,
                                      splashColor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: TextInput(
                                label: (prefs.nickname == null)
                                    ? "Actual: " +
                                        prefs.nombre +
                                        " " +
                                        prefs.apellido
                                    : prefs.nickname,
                                inputIcon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                                validator: (String text) {
                                  if (text.isEmpty) {
                                    return 'Por favor completar el campo';
                                  }
                                  nickNuevo = text;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ):Container(),
                Divider(color: Colors.white.withOpacity(0.2)),
                //FILTROS
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        'Filtros',
                        style: TextStyle(
                            fontSize: 30,
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
                    _opciones(size),
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
                            fontSize: 30,
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
                                IconButton(
                                    icon: (snapshot.data != 0)
                                        ? Icon(
                                            (snapshot.data <= 0.5)
                                                ? Icons.volume_down
                                                : Icons.volume_up,
                                            color: Colors.white)
                                        : Icon(Icons.volume_off),
                                    onPressed: () {
                                      if (snapshot.data != 0.0) {
                                        aux = snapshot.data;
                                        print(aux.toString());
                                        player.setVolume(0.0);
                                      } else {
                                        print(aux.toString());
                                        player.setVolume(aux);
                                      }
                                    }),
                                Expanded(
                                  child: Slider(
                                    divisions: 100,
                                    min: 0.0,
                                    max: 1.0,
                                    value: snapshot.data ?? 1.0,
                                    onChanged: player.setVolume,
                                  ),
                                ),
                                Text(
                                    '${(snapshot.data * 100).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Fixed',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0)),
                              ],
                            ),
                          );
                        }),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.2)),

                Container(
                  height: 50,
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1.0,
                      blurRadius: 0.9
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            child: ListTile(
                              title: AutoSizeText(
                                "Restablecer",
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
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
                        width: size.width * 0.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            child: ListTile(
                              title: AutoSizeText(
                                "Guardar",
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () async{
                                _submit();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    int detalle = 0;
    if (title == 'Materia')
      detalle = 3;
    else if (title == 'Arma')
      detalle = 1;
    else if (title == 'Curso') detalle = 2;
    print(detalle);
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ClipRRect(
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
                        (snapshot.hasData)
                            ? Expanded(
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: AutoSizeText(
                                    hint,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              )
                            : CircularProgressIndicator(),
                        IconButton(
                          icon: Icon(Icons.list_rounded,color: Colors.white,), 
                          onPressed: () => showDialog(context: context, child: _showOpcionesDialog(_getItems(snapshot.data, hint, detalle), title))
                        )
                      ],
                    ),
                  ),
                ),
                

                    /* childrenPadding:
                        EdgeInsets.symmetric(vertical: 7.0, horizontal: 25.0),
                    children: [
                      (prefs.arma == 'General' &&
                              (title != 'Arma' && title != 'Organismo'))
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3.0),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25),
                                    bottomLeft: Radius.circular(25)),
                                color: Colors.white,
                              ),
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: ListView(
                                children:
                                    getItems(snapshot.data, hint, detalle),
                              ),
                            )] */
              ],
            ),
          );
        });
  }


  Widget _showOpcionesDialog(List<Widget> listaOpciones, String title){
    return AlertaOpcionesWidget(
      title: title,
      children: listaOpciones,
    );
  }
  List<Widget> _getItems(data, String hint, int detalle) {
    List<Widget> lista = new List();

    if (data.isNotEmpty) {
      data.forEach((item) {
        lista.add(ListTile(
          contentPadding: EdgeInsets.all(0),
            onTap: () {
              switch (detalle) {
                case 0:
                  prefs.colegio = item.nombre;
                  break;
                case 1:
                  prefs.arma = item.nombre;
                  if (prefs.arma == 'General') {
                    prefs.curso = '';
                    prefs.materia = '';
                  }
                  break;
                case 2:
                  prefs.curso = item.nombre;
                  break;
                case 3:
                  prefs.materia = item.nombre;
                  break;
                default:
              }
              print(detalle);
              setState(() {});
            },
            title: Center(
                child: AutoSizeText(
                  item.nombre,
                  maxLines: 2,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize:
                          Theme.of(context).textTheme.headline6.fontSize),
                  textAlign: TextAlign.center,
                ))));
        lista.add(Divider(height: 1,));
      });
    }
    return lista;
  }

  uploadImage() async {
    imagen = await camaraController.getImage();
    setState(() {});
  }
}
