import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

class ArchiveButtonWidget extends StatelessWidget {
 const ArchiveButtonWidget(
      {required this.onPressed, this.hide = false, Key? key})
      : super(key: key);
  final Function() onPressed;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return RoundedTextButton(
      text: const AppTextWithDot(
          text: 'Archive',
          fontWeight: FontWeight.normal,
          fontSize: 12,
          color: Colors.red),
      backgroundColor: const Color(0xCCFDF1F3),
      radius: 15.0,
      paddingTop: 0,
      paddingBottom: 0,
      paddingLeft: 16,
      paddingRight: 16,
      onPressed: onPressed,
      hide: hide,
    );
  }
}
