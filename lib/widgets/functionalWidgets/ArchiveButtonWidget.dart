import 'package:debts_app/widgets/partialWidgets/RoundedButton.dart';
import 'package:flutter/material.dart';

import '../partialWidgets/AppTextWithDots.dart';

class ArchiveButtonWidget extends StatelessWidget {
  const ArchiveButtonWidget({required this.onPressed, Key? key})
      : super(key: key);
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: AppTextWithDot(
          text: 'Archive',
          fontWeight: FontWeight.normal,
          fontSize: 12,
          color: Colors.red),
      backgroundColor: const Color(0xCCFDF1F3),
      radius: 15.0,
      padding_top: 0,
      padding_bottom: 0,
      padding_left: 16,
      padding_right: 16,
      onPressed: onPressed,
    );
  }
}
