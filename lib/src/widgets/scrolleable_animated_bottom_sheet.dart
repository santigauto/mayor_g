import 'package:flutter/material.dart';

class DraggableAnimatedModal extends StatefulWidget {
  final Function dismissModal;
  DraggableAnimatedModal(this.dismissModal);
  @override
  _DraggableAnimatedModalState createState() => _DraggableAnimatedModalState();
}

class _DraggableAnimatedModalState extends State<DraggableAnimatedModal>{

  @override
  Widget build(BuildContext context) {
    double initialPercentage = 0.4;
    double border = 15.0;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return false;
      },
      child: Positioned.fill(
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
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color:Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft:(percentage > 0.7)?Radius.circular(border * (1-percentage)):Radius.circular(border),
                        topRight:(percentage > 0.7)?Radius.circular(border * (1-percentage)):Radius.circular(border),)
                    ),
                    height:double.infinity,width:double.infinity,
                    child: ListView(
                      controller: scrollController,
                    ),
                  ),
                  Column(
                    children: [
                      IgnorePointer(
                        child: Container(
                          height: 70.0,
                          child: Stack(
                            children: [
                              IgnorePointer(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: ListTile(
                                    title: Text(
                                      'Amigos',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,fontSize: Theme.of(context).textTheme.headline6.fontSize),
                                    ),
                                  )
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(1 - percentage),
                                    ),
                                    margin: EdgeInsets.only(top:10),
                                    height: 4.0,
                                    width: 90.0,
                                  )
                                ],
                              ),
                            ],
                          ),
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
                  ),
                  Positioned(
                    top: 10,
                    right: 15,
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(
                          context, 'search');
                  }),),
                  Positioned(
                    top: 10,
                    left: 15,
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      onPressed: widget.dismissModal,
                    )),
                ],
              );
            }
          );
        }),
      ));
}}