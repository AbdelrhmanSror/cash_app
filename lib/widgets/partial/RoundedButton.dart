import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    required this.radius,
    required this.backgroundColor,
    required this.paddingLeft,
    required this.paddingTop,
    required this.paddingRight,
    required this.paddingBottom,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final Widget text;
  final double radius;
  final Color backgroundColor;
  final double paddingLeft;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => backgroundColor),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(
            paddingLeft, paddingTop, paddingRight, paddingBottom)),
      ),
      onPressed: onPressed,
      child: text,
    );
  }
}
