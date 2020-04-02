import 'package:flutter/material.dart';
import 'package:mayor_g/views/new_match_page.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/side_menu_widget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: Container(width: 300, child: SideMenuWidget()),
        appBar: AppBar(
          title: Text('MayorG App'),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          height: 265,
                          width: 210,
                          child: Image.asset(
                            'assets/mayor.png',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        width: 210,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/mayor.png'))),
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
                      var route = MaterialPageRoute(builder: (context) => NewMatchPage());
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
          ],
        ),
      ),
    );
  }
}
