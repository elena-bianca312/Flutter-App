import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateX, translate }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final Axis axis;

  const FadeAnimation(this.delay, this.axis, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..add(AniProps.translate, Tween(begin: -30.0, end: 0.0), const Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
            offset: axis == Axis.vertical ? Offset(0, animation.get(AniProps.translate)) : Offset(animation.get(AniProps.translate), 0),
            child: child
        ),
      ),
    );
  }
}
