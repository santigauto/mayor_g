import 'package:flutter/material.dart';
import 'package:mayor_g/services/commons/friend_selector_service.dart';

import 'package:mayor_g/views/new_match_page.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/side_menu_widget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<bool> _back() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Quieres realmente salir de Mayor G'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('Salir')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('Cancelar'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    GetFriendsService().getFriends(context, dni: 1);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        drawer: Container(width: 300, child: SideMenuWidget()),
        appBar: AppBar(
          title: Text('MayorG App'),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.6,
                          child: Container(
                            padding: EdgeInsets.only(left: size.width * 0.05),
                            height: 310,
                            width: 250,
                            child: Image.asset(
                              'assets/MayorG-Fumando.gif',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: size.width * 0.5),
                          height: 310,
                          width: 250,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/MayorG-Fumando.gif'))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 215),
                          child: Container(
                            height: 100,
                            width: 250,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/mayorG@3x.png'))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    RaisedButton(
                      child: Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Comenzar  ", style: TextStyle(fontSize: 20)),
                            Icon(Icons.play_circle_filled)
                          ],
                        ),
                      ),
                      onPressed: () {
                        var route = MaterialPageRoute(
                            builder: (context) => NewMatchPage());
                        Navigator.push(context, route);
                      },
                      color: Colors.green[900],
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
