import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/services/commons/camara.dart';
import 'package:mayor_g/src/services/user/user_service.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';

class AjustesPartidaPage extends StatefulWidget {
  @override
  _AjustesPartidaPageState createState() => _AjustesPartidaPageState();
}

class _AjustesPartidaPageState extends State<AjustesPartidaPage> {

  

  final _formKey = GlobalKey<FormState>();
  final player = BackgroundMusic.backgroundAssetsAudioPlayer;
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
            padding: const EdgeInsets.only(right:5.0, left: 5.0, top: 10.0),
            child: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                SafeArea(child: Container()),
                //NICKNAME
                (routeData['logueado'])?Column(
                  children: [
                    ExpansionTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person,color: Colors.white,),
                        ],
                      ),
                      title: Text(
                        'Usuario',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical:5.0),
                        child: Text(
                          'Aquí puede modificar su Nickname \ny foto de perfil',
                          style: TextStyle(color: Colors.white),
                        ),
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
                    ),
                    Divider(color: Colors.white.withOpacity(0.2)),
                  ],
                ):Container(),
                //FILTROS
                (routeData['logueado'])?Column(
                  children: [
                    ExpansionTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_list_bulleted_rounded),
                        ],
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Filtros',
                            style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: Text(
                          'Filtre a su criterio las características de las preguntas',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      children: [
                        FiltrosWidget(),
                      ],
                    ),
                    Divider(color: Colors.white.withOpacity(0.2)),
                  ],
                ):Container(),
                //SONIDOS
                ExpansionTile(
                  leading: Icon(Icons.volume_down_rounded),
                  title: Row(
                    children: [
                      Text(
                        'Sonido',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  children: [
                    StreamBuilder<double>(
                        stream: player.volume,
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
          //BOTONES DE GUARDADO Y RESTABLECER
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1.0,
                      blurRadius: 0.9
                    )
                  ]
                ),
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
              )
            ],
          ),
        ],
      ),
    );
  }

  

  uploadImage() async {
    imagen = await camaraController.getImage(context);
    setState(() {});
  }
}
