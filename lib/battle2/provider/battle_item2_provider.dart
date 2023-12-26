import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_setting_test/battle2/widgets/battle_item2.dart';

class BattleItem2Provider with ChangeNotifier {
  State<BattleItem2> state;

  Duration longPressDuration = const Duration(milliseconds: 100);
  double pressPosition = 0.0;

  bool isSelectMode = false;

  int focused = -1;
  int prevFocused = -1;

  // animation
  late AnimationController _animation;
  late Animation<double> scaleAnimationA;
  late Animation<double> scaleAnimationB;
  late Animation<double> opacityAnimationA;
  late Animation<double> opacityAnimationB;
  late Animation<Offset> positionA;
  late Animation<Offset> positionB;

  void onLongPress() {
    isSelectMode = true;
    focused = -1;
    _animation.reverse();
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void onLongPressCancel() {
    isSelectMode = false;
    notifyListeners();
  }

  void onLongPressUp() async {
    isSelectMode = false;
    // focused = -1;
    // _animation.reverse();
    // focused = -1;
    // print('focused : ${focused}');
    // print('prev focused : ${prevFocused}');
    // if (focused == -1 && prevFocused != -1) {
    //   if (prevFocused == 0) {
    //     await startLeftAnimation();
    //   } else {
    //     await startRightAnimation();
    //   }
    //   focused = prevFocused;
    // }
    // notifyListeners();
  }

  void onLongPressStart(LongPressStartDetails details) {
    pressPosition = details.localPosition.dx;
    notifyListeners();
  }

  Future onLongPressMoveUpdate(LongPressMoveUpdateDetails details) async {
    if (details.localPosition.dx < pressPosition - 4) {
      pressPosition = details.localPosition.dx;
      await startRightAnimation();
      focused = 1;
      prevFocused = 1;
    } else if (details.localPosition.dx > pressPosition + 4) {
      pressPosition = details.localPosition.dx;

      await startLeftAnimation();
      focused = 0;
      prevFocused = 0;
    }
    notifyListeners();
  }

  void onLongPressEnd(LongPressEndDetails details) {
    pressPosition = 0.0;
    notifyListeners();
  }

  Future startLeftAnimation() async {
    if (!_animation.isAnimating) {
      if (focused == 0) return;

      await _animation.reverse();
      setupLeftAnimation();
      await _animation.forward();
      HapticFeedback.lightImpact();
    }
  }

  Future startRightAnimation() async {
    if (!_animation.isAnimating) {
      if (focused == 1) return;

      await _animation.reverse();
      setupRightAnimation();
      await _animation.forward();
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  BattleItem2Provider(this.state) {
    _animation = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: state as TickerProvider,
    );
    setupLeftAnimation();
  }

  void setupLeftAnimation() {
    scaleAnimationA = Tween<double>(begin: 1.0, end: 1.7).animate(_animation);
    scaleAnimationB = Tween<double>(begin: 1.0, end: 0.8).animate(_animation);
    opacityAnimationA = Tween<double>(begin: 1.0, end: 0.3).animate(_animation);
    opacityAnimationB = Tween<double>(begin: 1.0, end: 0.3).animate(_animation);
    positionA =
        Tween<Offset>(begin: const Offset(-.65, 0), end: const Offset(0, 0))
            .animate(_animation);
    positionB =
        Tween<Offset>(begin: const Offset(.65, 0), end: const Offset(.8, .35))
            .animate(_animation);
  }

  void setupRightAnimation() {
    scaleAnimationA = Tween<double>(begin: 1.0, end: .8).animate(_animation);
    scaleAnimationB = Tween<double>(begin: 1.0, end: 1.7).animate(_animation);
    opacityAnimationA = Tween<double>(begin: 1.0, end: 0.3).animate(_animation);
    opacityAnimationB = Tween<double>(begin: 1.0, end: 0.3).animate(_animation);
    positionA =
        Tween<Offset>(begin: const Offset(-.65, 0), end: const Offset(-.8, .35))
            .animate(_animation);
    positionB =
        Tween<Offset>(begin: const Offset(.65, 0), end: const Offset(0, 0))
            .animate(_animation);
  }
}
