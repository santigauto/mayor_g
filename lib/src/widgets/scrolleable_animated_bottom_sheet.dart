
import 'package:flutter/material.dart';
class DraggableAnimatedModal extends StatefulWidget {
  ///The [trailing] the [DraggableAnimatedModal] is a positioned widget which is in the topRight of the modal, 
  ///it is thought for a small widget like an [IconButton] or an [CircleAvatar].
  final Widget trailing;
  ///The [leading] the [DraggableAnimatedModal] is a positioned widget which is in the topRight of the modal, 
  ///it is thought for a small widget like an [IconButton] or an [CircleAvatar].
  final Widget leading;
  ///The [title] is a widget spotted in the middle of the header of the modal.
  final Widget title;
  ///The [modalBody] is a widget which will be the flexible content of the modal, it is thought for a scrollable widget
  ///like the [ListView], [SingleChildScrollView] or the [CustomScrollView]
  final Widget modalBody;
  /// Determinates if the top drag handler appears.
  /// [dragHandler] is [true] by default.
  final bool dragHandler;
  final Color color;
///This [DraggableAnimatedModal] was thought to being used as the content of a [showModalBottomSheet]
///to obtain the full modal dragging manipulation. However, it also can be implemented as an independent widget.
  DraggableAnimatedModal({this.trailing, this.leading, this.title, this.modalBody, this.dragHandler = true, this.color});

  @override
  _DraggableAnimatedModalState createState() => _DraggableAnimatedModalState();
}

class _DraggableAnimatedModalState extends State<DraggableAnimatedModal>{



  @override
  Widget build(BuildContext context) {

    
    Color auxColor;
    if(widget.color == null) auxColor = Theme.of(context).primaryColor;
    else auxColor = widget.color;
    double initialPercentage = 0.7;
    double border = 20.0;
    double size = 17.0;
    
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return false;
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: ()=> Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          DraggableScrollableSheet(
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
                double auxSize = (size * scaledPercentage <= 0)? 0:size * scaledPercentage;
                double auxBorder = (percentage > 0.7)? ((MediaQuery.of(context).size.height - scrollController.position.viewportDimension) * border) / (MediaQuery.of(context).size.height *0.3): border;
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:auxColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(auxBorder),
                          topRight: Radius.circular(auxBorder),)
                      ),
                      height:double.infinity,width:double.infinity,
                      child: ListView(
                        controller: scrollController,
                      ),
                    ),
                    Column(
                      children: [
                        IgnorePointer(
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: auxSize),
                                    ListTile(
                                      title: (widget.title != null)? Container(width:double.infinity, child: Center(child:widget.title)) : Container()
                                    ),
                                  ],
                                )
                              ),
                              (widget.dragHandler)?_dragHandler(percentage): Container(),
                            ],
                          ),
                        ),
                        Flexible(
                          child: widget.modalBody
                        )
                      ],
                    ),
                    Positioned(
                      top: 10 + auxSize,
                      left: 0,
                      child: (widget.leading != null)? widget.leading : Container()),
                    Positioned(
                      top: 10 + auxSize,
                      right: 0,
                      child: (widget.trailing != null)? widget.trailing : Container()),
                  ],
                );
              }
            );
          }),
        ],
      ));
}
Widget _dragHandler(double percentage){
  return Row(
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
  );
}

}