import 'package:flutter/material.dart';

class CompositeWidget extends StatelessWidget {
  CompositeWidget(
      {required this.width,
      required this.widgets,
      this.vertical = false,
      Key? key})
      : super(key: key);
  List<Widget> widgets = [];
  bool vertical;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < widgets.length; i++)
            Container(
                //to limit the width the widget can expand
                constraints: BoxConstraints(minWidth: 1, maxWidth: width),
                child: widgets[i]),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < widgets.length; i++)
          Container(
              //to limit the width the widget can expand
              constraints: BoxConstraints(minWidth: 1, maxWidth: width),
              child: widgets[i]),
      ],
    );
  }
}
