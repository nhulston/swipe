import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'animations.dart';
import 'controller.dart';
import 'swipe_info.dart';

typedef ForwardCallback = Function(int index, SwipeInfo info);
typedef BackCallback = Function(int index, SwipeInfo info);
typedef EndCallback = Function();

/// We forked this from this package: https://pub.dev/packages/tcard
class TinderSwipe extends StatefulWidget {
  final Size size;
  List<Widget> cards;
  final Function? onForward;
  final Function? onBack;
  final EndCallback? onEnd;
  final TCardController? controller;
  final bool lockYAxis;

  /// How quick should it be slided? less is slower. 10 is a bit slow. 20 is a quick enough.
  final double slideSpeed;

  /// How long does it have to wait until the next slide is sliable? less is quicker. 100 is fast enough. 500 is a bit slow.
  final int delaySlideFor;

  TinderSwipe({
    required this.cards,
    this.controller,
    this.onForward,
    this.onBack,
    this.onEnd,
    this.lockYAxis = false,
    this.slideSpeed = 20,
    this.delaySlideFor = 500,
    this.size = const Size(380, 400),
  })  : assert(cards.length > 0);

  @override
  TinderSwipeState createState() => TinderSwipeState();
}

class TinderSwipeState extends State<TinderSwipe> with TickerProviderStateMixin {
  List<Widget> cards = [];
  // Card swipe directions
  final List<SwipeInfo> _swipInfoList = [];
  List<SwipeInfo> get swipInfoList => _swipInfoList;

  int _frontCardIndex = 0;
  int get frontCardIndex => _frontCardIndex;

  Alignment _frontCardAlignment = CardAlignments.front;
  double _frontCardRotation = 0.0;
  late AnimationController _cardChangeController;
  late AnimationController _cardReverseController;
  late Animation<Alignment> _reboundAnimation;
  late AnimationController _reboundController;
  Widget _frontCard(BoxConstraints constraints) {
    Widget child =
    _frontCardIndex < widget.cards.length ? widget.cards[_frontCardIndex] : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    Widget rotate = Transform.rotate(
      angle: (math.pi / 180.0) * _frontCardRotation,
      child: SizedBox.fromSize(
        size: CardSizes.front(constraints),
        child: child,
      ),
    );

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.frontCardShowAnimation(
          _cardReverseController,
          CardAlignments.front,
          _swipInfoList[_frontCardIndex],
        ).value,
        child: rotate,
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.frontCardDisappearAnimation(
          _cardChangeController,
          _frontCardAlignment,
          _swipInfoList[_frontCardIndex],
        ).value,
        child: rotate,
      );
    } else {
      return Align(
        alignment: _frontCardAlignment,
        child: rotate,
      );
    }
  }

  // 中间的卡片
  Widget _middleCard(BoxConstraints constraints) {
    Widget child = _frontCardIndex < widget.cards.length - 1
        ? widget.cards[_frontCardIndex + 1]
        : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.middleCardAlignmentAnimation(
          _cardReverseController,
        ).value,
        child: SizedBox.fromSize(
          size: CardReverseAnimations.middleCardSizeAnimation(
            _cardReverseController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.middleCardAlignmentAnimation(
          _cardChangeController,
        ).value,
        child: SizedBox.fromSize(
          size: CardAnimations.middleCardSizeAnimation(
            _cardChangeController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else {
      return Align(
        alignment: CardAlignments.middle,
        child: SizedBox.fromSize(
          size: CardSizes.middle(constraints),
          child: child,
        ),
      );
    }
  }

  // 后面的卡片
  Widget _backCard(BoxConstraints constraints) {
    Widget child = _frontCardIndex < widget.cards.length - 2
        ? widget.cards[_frontCardIndex + 2]
        : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.backCardAlignmentAnimation(
          _cardReverseController,
        ).value,
        child: SizedBox.fromSize(
          size: CardReverseAnimations.backCardSizeAnimation(
            _cardReverseController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.backCardAlignmentAnimation(
          _cardChangeController,
        ).value,
        child: SizedBox.fromSize(
          size: CardAnimations.backCardSizeAnimation(
            _cardChangeController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else {
      return Align(
        alignment: CardAlignments.back,
        child: SizedBox.fromSize(
          size: CardSizes.back(constraints),
          child: child,
        ),
      );
    }
  }

  bool _isAnimating() {
    return _cardChangeController.status == AnimationStatus.forward ||
        _cardReverseController.status == AnimationStatus.forward;
  }

  void _runReboundAnimation(Offset pixelsPerSecond, Size size) {
    _reboundAnimation = _reboundController.drive(
      AlignmentTween(
        begin: _frontCardAlignment,
        end: CardAlignments.front,
      ),
    );

    final double unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final double unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;
    const spring = SpringDescription(mass: 30.0, stiffness: 1.0, damping: 1.0);
    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _reboundController.animateWith(simulation);
    _resetFrontCard();
  }

  void _runChangeOrderAnimation() {
    if (_isAnimating()) {
      return;
    }

    if (_frontCardIndex >= widget.cards.length) {
      return;
    }

    _cardChangeController.reset();
    _cardChangeController.forward();
  }

  get runChangeOrderAnimation => _runChangeOrderAnimation;

  void _runReverseOrderAnimation() {
    if (_isAnimating()) {
      return;
    }

    if (_frontCardIndex == 0) {
      _swipInfoList.clear();
      return;
    }

    _cardReverseController.reset();
    _cardReverseController.forward();
  }

  get runReverseOrderAnimation => _runReverseOrderAnimation;

  void _forwardCallback() {
    _frontCardIndex++;
    _resetFrontCard();
    if (widget.onForward != null && widget.onForward is Function) {
      widget.onForward!(
        _frontCardIndex,
        _swipInfoList[_frontCardIndex - 1],
      );
    }

    if (widget.onEnd != null &&
        widget.onEnd is Function &&
        _frontCardIndex >= widget.cards.length) {
      widget.onEnd!();
    }
  }

  // Back animation callback
  void _backCallback() {
    _resetFrontCard();
    _swipInfoList.removeLast();
    if (widget.onBack != null && widget.onBack is Function) {
      int index = _frontCardIndex > 0 ? _frontCardIndex - 1 : 0;
      SwipeInfo info = _swipInfoList.isNotEmpty
          ? _swipInfoList[index]
          : SwipeInfo(-1, SwipeDirection.none);

      widget.onBack!(_frontCardIndex, info);
    }
  }

  void _resetFrontCard() {
    _frontCardRotation = 0.0;
    _frontCardAlignment = CardAlignments.front;
    setState(() {});
  }

  void reset({List<Widget>? cards}) {
    widget.cards.clear();
    if (cards != null) {
      widget.cards.addAll(cards);
    } else {
      widget.cards.addAll(widget.cards);
    }
    _swipInfoList.clear();
    _frontCardIndex = 0;
    _resetFrontCard();
  }

  // Stop animations
  void _stop() {
    _reboundController.stop();
    _cardChangeController.stop();
    _cardReverseController.stop();
  }

  void _updateFrontCardAlignment(DragUpdateDetails details, Size size) {
    _frontCardAlignment += Alignment(
      details.delta.dx / (size.width / 2) * widget.slideSpeed,
      widget.lockYAxis
          ? 0
          : details.delta.dy / (size.height / 2) * widget.slideSpeed,
    );

    _frontCardRotation = _frontCardAlignment.x;
    setState(() {});
  }

  void _judgeRunAnimation(DragEndDetails details, Size size) {
    const double limit = 10.0;
    final bool isSwipLeft = _frontCardAlignment.x < -limit;
    final bool isSwipRight = _frontCardAlignment.x > limit;

    if (isSwipLeft || isSwipRight) {
      _runChangeOrderAnimation();
      if (isSwipLeft) {
        _swipInfoList.add(SwipeInfo(_frontCardIndex, SwipeDirection.left));
      } else {
        _swipInfoList.add(SwipeInfo(_frontCardIndex, SwipeDirection.right));
      }
    } else {
      _runReboundAnimation(details.velocity.pixelsPerSecond, size);
    }
  }

  @override
  void initState() {
    super.initState();

    // widget.cards.addAll(widget.cards);

    if (widget.controller != null && widget.controller is TCardController) {
      widget.controller!.bindState(this);
    }

    _cardChangeController = AnimationController(
      duration: Duration(milliseconds: widget.delaySlideFor),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _forwardCallback();
        }
      });

    _cardReverseController = AnimationController(
      duration: Duration(milliseconds: widget.delaySlideFor),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _frontCardIndex--;
        } else if (status == AnimationStatus.completed) {
          _backCallback();
        }
      });

    _reboundController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.delaySlideFor),
    )..addListener(() {
      setState(() {
        _frontCardAlignment = _reboundAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _cardReverseController.dispose();
    _cardChangeController.dispose();
    _reboundController.dispose();
    if (widget.controller != null) {
      widget.controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building tinder cards: $widget.cards');
    return SizedBox.fromSize(
      size: widget.size,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = MediaQuery.of(context).size;

          return Stack(
            children: <Widget>[
              _backCard(constraints),
              _middleCard(constraints),
              _frontCard(constraints),
              _cardChangeController.status != AnimationStatus.forward
                  ? SizedBox.expand(
                child: GestureDetector(
                  onPanDown: (DragDownDetails details) {
                    _stop();
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    _updateFrontCardAlignment(details, size);
                  },
                  onPanEnd: (DragEndDetails details) {
                    _judgeRunAnimation(details, size);
                  },
                ),
              )
                  : const IgnorePointer(),
            ],
          );
        },
      ),
    );
  }
}
