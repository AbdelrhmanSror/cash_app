import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectangleTitleArea extends StatelessWidget {
  const RectangleTitleArea(
      {Key? key,
      required this.title1,
      required this.subTitle1,
      required this.title2,
      required this.subTitle2,
      required this.radius})
      : super(key: key);

  final Widget title1;
  final Widget subTitle1;
  final Widget title2;
  final Widget subTitle2;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [title1, subTitle1]),
            const Icon(Icons.arrow_forward, size: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [title2, subTitle2],
            )
          ],
        ),
      ),
    ]);
  }
}
