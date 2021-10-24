import 'dart:math';
import 'tinder_swipe.dart';
import 'swipe_info.dart';

/// Card controller
class TCardController {
  TinderSwipeState? state;

  void bindState(TinderSwipeState state) {
    this.state = state;
  }

  int get index => state?.frontCardIndex ?? 0;

  forward({SwipeDirection? direction}) {
    direction ??= Random().nextBool() ? SwipeDirection.left : SwipeDirection.right;

    state!.swipInfoList.add(SwipeInfo(state!.frontCardIndex, direction));
    state!.runChangeOrderAnimation();
  }

  back() {
    state!.runReverseOrderAnimation();
  }

  get reset => state!.reset;

  void dispose() {
    state = null;
  }
}
