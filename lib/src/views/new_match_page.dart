import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/utils/friend_modal.dart';
import 'package:mayor_g/src/views/question_page.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/loading_widget.dart';
import 'package:mayor_g/src/widgets/pulse_animator.dart';
import 'package:mayor_g/src/widgets/scrollable_exhibition_bottom_sheet.dart';
/* import 'package:mayor_g/src/widgets/scrollable_exhibition_bottom_sheet.dart'; */

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({Key key}) : super(key: key);

  @override
  _NewMatchPageState createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {
  bool _isLoading = false;
  bool _modalActivated = false;
  bool _modoClasico = true;
  bool _modoDuelo = true;
  bool _selecOponente = true;
  bool _selecAlAzar = true;
  bool _canPlay = false;
  ListaPreguntasNuevas preguntas;

  @override
  void initState() {
    super.initState();
  }

  Modal modal = new Modal();

  void _playAction() async {
    if (_canPlay == true) {
      preguntas =
          await QuestionServicePrueba().getNewQuestions(context, cantidad: 10);
      if (preguntas == null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        var route = new MaterialPageRoute(
            builder: (context) => QuestionPage(questions: preguntas, n: 0));
        Navigator.pushReplacement(context, route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color _noSeleccionado = Theme.of(context).primaryColor.withOpacity(0.2);
    Color _seleccionado = Theme.of(context).primaryColor;
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _initMatchButton(context),
                  SizedBox(
                    height: 20,
                  ),
                  _modoDeJuego(_seleccionado, _noSeleccionado),
                  SizedBox(
                    height: 20,
                  ),
                  _seleccionOponente(_seleccionado, _noSeleccionado, preguntas)
                ],
              ),
            ),
            (_modalActivated)
                ? Stack(children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _modalActivated = !_modalActivated;
                          });
                        },
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                        )),
                    /* SafeArea(child: _modal(context)) */
                    DraggableAnimatedModal((){
                                  _modalActivated = !_modalActivated;
                                  setState(() {});
                                })
                      /* ScrollableExhibitionSheet() */
                  ])
                : Container(),
            (_isLoading)
                ? LoadingWidget(
                    caption: Text('Cargando partida, aguarde...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _initMatchButton(context) {
    if (_canPlay) {
      return RaisedButton(
        color: Colors.transparent,
        child: Container(
          height: 200,
          width: 200,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              image: DecorationImage(
                image: AssetImage('assets/shape15.png'),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(0, 0), color: Colors.black, blurRadius: 5),
              ]),
          child: Center(
              child: PulseAnimatorWidget(
            begin: 0.5,
            child: Text(
              '¡JUGAR!',
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
          )),
        ),
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          _playAction();
        },
        shape: CircleBorder(),
        disabledTextColor: Colors.grey,
      );
    } else {
      return Container();
    }
  }

  Widget _modoDeJuego(Color colorSelec, Color colorNoSelec) {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: BorderedText(
              strokeColor: Colors.white,
              child: Text(
                'Modo de Juego',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Container(
                child: Text("CLÁSICO", style: TextStyle(fontSize: 20)),
              ),
              color: (_modoClasico) ? colorSelec : colorNoSelec,
              onPressed: () {
                setState(() {
                  _canPlay = true;
                  _modoClasico = true;
                  _modoDuelo = false;
                });
              },
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
            RaisedButton(
              child: Container(
                child: Text(" DUELO ", style: TextStyle(fontSize: 20)),
              ),
              color: (_modoDuelo) ? colorSelec : colorNoSelec,
              onPressed: () {
                setState(() {
                  _canPlay = false;
                  _modoDuelo = true;
                  _modoClasico = false;
                });
              },
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seleccionOponente(
      Color colorSelec, Color colorNoSelec, ListaPreguntasNuevas preguntas) {
    if (_modoDuelo && !_modoClasico) {
      return Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: BorderedText(
                strokeColor: Colors.white,
                child: Text(
                  'Oponente',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.white),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Container(
                  child: Text("AMIGOS", style: TextStyle(fontSize: 20)),
                ),
                color: (_selecOponente == true) ? colorSelec : colorNoSelec,
                onPressed: () {
                  setState(() {
                    _selecAlAzar = false;
                    _canPlay = false;
                    _selecOponente = true;
                    _modalActivated = true;
                  });
                  //modal.mainBottomSheet(context, preguntas);
                },
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              RaisedButton(
                child: Container(
                  child: Text("AL AZAR", style: TextStyle(fontSize: 20)),
                ),
                color: (_selecAlAzar == true) ? colorSelec : colorNoSelec,
                onPressed: () {
                  setState(() {
                    _selecOponente = false;
                    _canPlay = true;
                    _selecAlAzar = true;
                  });
                },
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

}

class DraggableAnimatedModal extends StatefulWidget {
  final Function dismissModal;
  DraggableAnimatedModal(this.dismissModal);
  @override
  _DraggableAnimatedModalState createState() => _DraggableAnimatedModalState();
}

class _DraggableAnimatedModalState extends State<DraggableAnimatedModal> {
  @override
  Widget build(BuildContext context) {
    double initialPercentage = 0.3;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return false;
      },
      child:  Positioned.fill(
              child: DraggableScrollableSheet(
            initialChildSize: initialPercentage,
            minChildSize: initialPercentage,
            builder: (context, scrollController) {
              return AnimatedBuilder(
                animation: scrollController,
                builder: (context, _ ) {
                  double percentage = initialPercentage;
                if (scrollController.hasClients) {
                  percentage = (scrollController.position.viewportDimension) /
                      (MediaQuery.of(context).size.height);
                }
                double scaledPercentage =
                    (percentage - initialPercentage) / (1 - initialPercentage);
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: 70.0,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: ListTile(
                                  title: Text(
                                    'Amigos',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.popAndPushNamed(
                                            context, 'search');
                                      }),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                      onPressed: widget.dismissModal)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.drag_handle, color: Colors.white)
                              ],
                            ),
                            ListView(controller: scrollController, children: [
                              ListTile(
                                  leading: IconButton(
                                      icon: Icon(
                                        Icons.person_add,
                                        color: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        Navigator.popAndPushNamed(
                                            context, 'search');
                                      }),
                                  trailing: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                    child: IconButton(
                                        iconSize: 30,
                                        icon: Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: widget.dismissModal,
                                  )),)
                            ]),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('tile numero $index'),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  );
                }
              );
          }),
    ));
}
}
