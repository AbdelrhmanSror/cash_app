import 'package:flutter/material.dart';

class RoundedTextButton extends StatelessWidget {
  RoundedTextButton({
    required this.text,
    required this.radius,
    required this.backgroundColor,
    required this.paddingLeft,
    required this.paddingTop,
    required this.paddingRight,
    required this.paddingBottom,
    required this.onPressed,
    this.hide = false,
    this.elevation = 5.0,
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
  final bool hide;
  double elevation;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: hide ? 0.0 : 1.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(radius),
                bottom: Radius.circular(radius),
              ),
            ),
            primary: backgroundColor,
            elevation: elevation,
            padding: EdgeInsets.fromLTRB(
                paddingLeft, paddingTop, paddingRight, paddingBottom)),
        onPressed: hide ? null : onPressed,
        child: text,
      ),
    );
  }
}
