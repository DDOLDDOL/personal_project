import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CustomPaintContainer extends StatelessWidget {
  const CustomPaintContainer({
    Key? key,
    required this.onPaint,
    this.autoSaveAndRestoreCanvas = true,
    this.child,
  }) : super(key: key);

  final void Function(CustomPaintUtil, Size) onPaint;
  final bool autoSaveAndRestoreCanvas;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomPaintUtil(
        onPaint: onPaint,
        autoSaveAndRestore: autoSaveAndRestoreCanvas,
      ),
      child: child,
    );
  }
}
