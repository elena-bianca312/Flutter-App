import 'dart:ui';
import 'package:flutter/material.dart';
// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables


final _borderRadius = BorderRadius.circular(20);

// ignore: must_be_immutable
class GlassBox extends StatelessWidget {

  final double? height;
  final double? width;
  final Color? color;
  double? addedOpacity;
  final child;

  GlassBox({
    this.width,
    this.height,
    this.color,
    this.addedOpacity,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    addedOpacity ??= 0;
    return ClipRRect(
      borderRadius: _borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2
              ),
              child: Container(),
            ),

            // gradient effect
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: color != null ? color!.withOpacity(0.1) : Colors.white.withOpacity(0.1 + addedOpacity!)),
                borderRadius: _borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color != null ? color!.withOpacity(0.4 + addedOpacity!) : Colors.white.withOpacity(0.4 + addedOpacity!),
                    color != null ? color!.withOpacity(0.15 + addedOpacity!) : Colors.white.withOpacity(0.15 + addedOpacity!),
                  ],
                ),
              ),
            ),

            // child
            Center(
              child: child,
            ),
          ],
        )
      ),
    );
  }
}