import 'package:flutter/material.dart';

class SpinningIconButton extends AnimatedWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final AnimationController controller;

  const SpinningIconButton(
      {Key? key,
      required this.controller,
      this.iconData = Icons.sync,
      required this.onPressed})
      : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    final Animation<double> _animation = CurvedAnimation(
      parent: controller,
      // Use whatever curve you would like, for more details refer to the Curves class
      curve: Curves.linearToEaseOut,
    );

    return RotationTransition(
      turns: _animation,
      child: IconButton(
        icon: Icon(
          iconData,
          color: Colors.blue,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SyncButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SyncButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _SyncButtonState createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return SpinningIconButton(
      controller: _animationController,
      iconData: Icons.sync,
      onPressed: () async {
        // Play the animation infinitely
        _animationController.repeat();
        widget.onPressed();
        // Complete current cycle of the animation
        _animationController.forward(from: _animationController.value);
      },
    );
  }
}
