import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    required this.text,
    required this.radius,
    required this.backgroundColor,
    required this.padding_left,
    required this.padding_top,
    required this.padding_right,
    required this.padding_bottom,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final Widget text;
  final double radius;
  final Color backgroundColor;
  final double padding_left;
  final double padding_top;
  final double padding_right;
  final double padding_bottom;
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
            padding_left, padding_top, padding_right, padding_bottom)),
      ),
      onPressed: onPressed,
      child: text,
    );
  }
}
