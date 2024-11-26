import 'package:flutter/material.dart';

class WidgetAudioController extends StatefulWidget {
  const WidgetAudioController({super.key});

  @override
  State<WidgetAudioController> createState() => _WidgetAudioControllerState();
}

class _WidgetAudioControllerState extends State<WidgetAudioController>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, value) {
          return Container(
            height: 50,
            width: animation.value * MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade600.withOpacity(0.6),
            ),
          );
        });
  }
}
