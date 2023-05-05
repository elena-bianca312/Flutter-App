import 'dart:ui';
import 'package:flutter/material.dart';
// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables


final _borderRadius = BorderRadius.circular(20);

class GlassBox extends StatelessWidget {

  final double height;
  final double width;
  final child;

  const GlassBox({
    required this.width,
    required this.height,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
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
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                borderRadius: _borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.1),
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