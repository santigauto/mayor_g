import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/side_menu_widget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: Container(
          width: 250,
          child: SideMenuWidget()
        ),
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text('MayorG App'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background_myg.jpeg'),
                      fit: BoxFit.fill)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
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
                    onPressed: () {},
                    color: Colors.green[900],
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
