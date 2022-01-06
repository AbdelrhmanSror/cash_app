import 'package:flutter/material.dart';

class CompositeTextWidget extends StatelessWidget {
  CompositeTextWidget(
      {required this.width,
      required this.texts,
      this.vertical = false,
      Key? key})
      : super(key: key);
  List<Widget> texts = [];
  bool vertical;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < texts.length; i++)
            Container(
                constraints: BoxConstraints(minWidth: 1, maxWidth: width),
                child: texts[i]),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < texts.length; i++)
          Container(
              constraints: BoxConstraints(minWidth: 1, maxWidth: width),
              child: texts[i]),
      ],
    );
  }
}
