import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';

typedef LikeCallback = void Function();

class LikeDislikeAnimation extends StatefulWidget {

  final LikeCallback onLike;
  final LikeCallback onDislike;
  final LikeCallback onRemoveLike;
  final LikeCallback onRemoveDislike;
  final bool checkIfLiked;
  final bool checkIfDisliked;
  const LikeDislikeAnimation({
    super.key,
    required this.onLike,
    required this.onDislike,
    required this.onRemoveLike,
    required this.onRemoveDislike,
    required this.checkIfLiked,
    required this.checkIfDisliked
  });

  @override
  // ignore: library_private_types_in_public_api
  _LikeDislikeAnimationState createState() => _LikeDislikeAnimationState();
}

class _LikeDislikeAnimationState extends State<LikeDislikeAnimation> with TickerProviderStateMixin {
  late bool isLiked;
  late bool isDisliked;
  late AnimationController _likeController;
  late AnimationController _dislikeController;
  late Animation<Color?> _likeColorAnimation;
  late Animation<Color?> _dislikeColorAnimation;
  late Animation<Color?> _likeColorAnimationGreyToBlue;
  late Animation<Color?> _likeColorAnimationBlueToGrey;
  late Animation<Color?> _dislikeColorAnimationGreyToBlue;
  late Animation<Color?> _dislikeColorAnimationBlueToGrey;
  late Animation<double> _likeSizeAnimation = Tween<double>(begin: defaultSize, end: defaultSize).animate(_likeCurve);
  late Animation<double> _dislikeSizeAnimation = Tween<double>(begin: defaultSize, end: defaultSize).animate(_dislikeCurve);
  late CurvedAnimation _likeCurve;
  late CurvedAnimation _dislikeCurve;
  double defaultSize = 30;
  double increasedSize = 50;
  int animationDurationInMilliseconds = 200;
  late Animation<double> _likeSizeAnimationResponsive;
  late Animation<double> _dislikeSizeAnimationResponsive;

  @override
  void initState() {
    super.initState();

    isLiked = widget.checkIfLiked;
    isDisliked = widget.checkIfDisliked;

    _likeController = AnimationController(
      duration: Duration(milliseconds: animationDurationInMilliseconds),
      vsync: this,
    );

    _dislikeController = AnimationController(
      duration: Duration(milliseconds: animationDurationInMilliseconds),
      vsync: this,
    );

    _likeCurve = CurvedAnimation(parent: _likeController, curve: Curves.slowMiddle);
    _dislikeCurve = CurvedAnimation(parent: _dislikeController, curve: Curves.slowMiddle);

    _likeColorAnimationGreyToBlue = ColorTween(begin: Colors.grey[400], end: kCustomBlue).animate(_likeCurve);
    _likeColorAnimationBlueToGrey = ColorTween(begin: kCustomBlue, end: Colors.grey[400]).animate(_likeCurve);
    _dislikeColorAnimationGreyToBlue = ColorTween(begin: Colors.grey[400], end: kCustomBlue).animate(_dislikeCurve);
    _dislikeColorAnimationBlueToGrey = ColorTween(begin: kCustomBlue, end: Colors.grey[400]).animate(_dislikeCurve);
    _likeColorAnimation = isLiked ? _likeColorAnimationBlueToGrey : _likeColorAnimationGreyToBlue;
    _dislikeColorAnimation = isDisliked ? _dislikeColorAnimationBlueToGrey : _dislikeColorAnimationGreyToBlue;

    _likeSizeAnimationResponsive =
      TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: defaultSize, end: increasedSize),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: defaultSize, end: defaultSize),
        weight: 50,
      ),
    ]).animate(_likeCurve) ;

    _dislikeSizeAnimationResponsive =
      TweenSequence(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: defaultSize, end: increasedSize),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: increasedSize, end: defaultSize),
          weight: 50,
        ),
      ]).animate(_dislikeCurve);
  }

  @override
  void dispose() {
    super.dispose();
    _likeController.dispose();
    _dislikeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge(
            [_likeController, _dislikeController]),
        builder: (BuildContext context, _) {
          return Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_circle_up,
                  color:  _likeColorAnimation.value,
                  size: _likeSizeAnimation.value,
                ),
                onPressed: () {
                  _likeColorAnimation = _likeColorAnimationGreyToBlue;
                  _dislikeColorAnimation = _dislikeColorAnimationGreyToBlue;
                  isLiked ? {
                    _likeController.reverse(),
                    widget.onRemoveLike(),
                    _dislikeSizeAnimation = Tween<double>(begin: defaultSize, end: defaultSize).animate(_dislikeCurve),
                    isLiked = false,
                  } : {
                    _dislikeController.reverse(),
                    _likeController.forward(),
                    widget.onRemoveDislike(),
                    widget.onLike(),
                    _dislikeSizeAnimation = isDisliked ?
                      Tween<double>(begin: defaultSize, end: defaultSize).animate(_dislikeCurve) :
                      _dislikeSizeAnimationResponsive,
                    _likeSizeAnimation = _likeSizeAnimationResponsive,
                    isLiked = true,
                    isDisliked = false
                  };
                },
              ),
              const SizedBox(width: 25,),
              IconButton(
                icon: Icon(
                  Icons.arrow_circle_down,
                  color: _dislikeColorAnimation.value,
                  size: _dislikeSizeAnimation.value,
                ),
                onPressed: () {
                  _likeColorAnimation = _likeColorAnimationGreyToBlue;
                  _dislikeColorAnimation = _dislikeColorAnimationGreyToBlue;
                  isDisliked ? {
                    _dislikeController.reverse(),
                    widget.onRemoveDislike(),
                    _likeSizeAnimation = Tween<double>(begin: defaultSize, end: defaultSize).animate(_likeCurve),
                    isDisliked = false,
                  } : {
                    _likeController.reverse(),
                    _dislikeController.forward(),
                    widget.onRemoveLike(),
                    widget.onDislike(),
                    _likeSizeAnimation = isLiked ?
                      Tween<double>(begin: defaultSize, end: defaultSize).animate(_likeCurve) :
                      _likeSizeAnimationResponsive,
                    _dislikeSizeAnimation = _dislikeSizeAnimationResponsive,
                    isDisliked = true,
                    isLiked = false,
                  };
                }
              ),
            ],
          );
        });
  }
}