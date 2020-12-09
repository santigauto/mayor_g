import 'package:flutter/material.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';


class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          ListView.builder(
            itemCount: 3,
            itemBuilder: (context,i){
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey,)),
                  color: Colors.white.withOpacity(0.7),
                ),
                child: ListTile(
                  title: Text('item $i'),
                ),
              );
          }),
        ],
      ),
    );
  }
}