import 'package:flutter/material.dart';

typedef LikeCallback = void Function();
typedef CheckLikeCallback = bool Function();

class LikeDislikeAnimation extends StatefulWidget {

  final LikeCallback onLike;
  final LikeCallback onDislike;
  final LikeCallback onRemoveLike;
  final LikeCallback onRemoveDislike;
  final CheckLikeCallback checkIfLiked;
  final CheckLikeCallback checkIfDisliked;
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
  late bool isLiked = widget.checkIfLiked();
  late bool isDisliked = widget.checkIfDisliked();
  late AnimationController _likeController;
  late AnimationController _dislikeController;
  late Animation<Color?> _likeColorAnimation;
  late Animation<Color?> _dislikeColorAnimation;
  late Animation<double> _likeSizeAnimation;
  late Animation<double> _dislikeSizeAnimation;
  late CurvedAnimation _likeCurve;
  late CurvedAnimation _dislikeCurve;
  double defaultSize = 30;
  double increasedSize = 50;
  int animationDurationInMilliseconds = 200;

  @override
  void initState() {
    super.initState();

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

    // TODO
    // Both print false, but why??????? It shouldnt be like this
    // Probably because of the functions widget.checkIfLiked() and widget.checkIfDisliked()
    // So, review implementation of these functions
    print(isLiked);
    print(isDisliked);

    _likeColorAnimation = isLiked ?
      ColorTween(begin: Colors.blue, end: Colors.grey[400]).animate(_likeCurve) :
      ColorTween(begin: Colors.grey[400], end: Colors.blue).animate(_likeCurve);

    _dislikeColorAnimation = isDisliked ?
      ColorTween(begin: Colors.blue, end: Colors.grey[400]).animate(_dislikeCurve) :
      ColorTween(begin: Colors.grey[400], end: Colors.blue).animate(_dislikeCurve);

    _likeSizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: defaultSize, end: increasedSize),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: defaultSize, end: defaultSize),
        weight: 50,
      ),
    ]).animate(_likeCurve);

    _dislikeSizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: defaultSize, end: increasedSize),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: isLiked ? Tween<double>(begin: increasedSize, end: defaultSize) : Tween<double>(begin: defaultSize, end: defaultSize),
        weight: 50,
      ),
    ]).animate(_dislikeCurve);

    _likeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isLiked = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isLiked = false;
        });
      }
    });

    _dislikeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isDisliked = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isDisliked = false;
        });
      }
    });
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
                  color: _likeColorAnimation.value,
                  size: _likeSizeAnimation.value,
                ),
                onPressed: () {
                  isLiked ? {
                    _likeController.reverse(),
                    widget.onRemoveLike(),
                  } : {
                    _dislikeController.reverse(),
                    _likeController.forward(),
                    widget.onRemoveDislike(),
                    widget.onLike(),
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
                  isDisliked ? {
                    _dislikeController.reverse(),
                    widget.onRemoveDislike(),
                  } : {
                    _likeController.reverse(),
                    _dislikeController.forward(),
                    widget.onRemoveLike(),
                    widget.onDislike(),
                  };
                }
              ),
            ],
          );
        });
  }
}