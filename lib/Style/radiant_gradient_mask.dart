import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe/Style/app_colors.dart';
import 'dart:ui' as ui;

class RadiantGradientMask extends StatelessWidget {
  @override
  const RadiantGradientMask({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return ui.Gradient.linear(
          const Offset(4.0, 24.0),
          const Offset(24.0, 4.0),
          [
            AppColors.red,
            AppColors.orange,
          ],
        );
      },
      child: child,
    );
  }
}