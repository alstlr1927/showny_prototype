import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_setting_test/battle2/provider/battle_test2_provider.dart';
import 'package:flutter_setting_test/battle2/widgets/battle_item2.dart';
import 'package:flutter_setting_test/main/provider/test_provider.dart';
import 'package:flutter_setting_test/model/battle.dart';
import 'package:provider/provider.dart';

class BattleItem2Provider with ChangeNotifier {
  State<BattleItem2> state;

  Duration longPressDuration = const Duration(milliseconds: 100);
  double pressPosition = 0.0;

  bool isSelectMode = false;

  int focused = -1;

  late BattleTest2Provider battleProvider;
  late TestProvider testProvider;

  // animation
  late AnimationController _animation;
  late Animation<double> scaleAnimationA;
  late Animation<double> scaleAnimationB;
  // late Animation<double> opacityAnimationA;
  // late Animation<double> opacityAnimationB;
  late Animation<Offset> positionA;
  late Animation<Offset> positionB;

  void setFocused(int value) {
    if (value != -1) {
      if (value == 0) {
        setBattleData(state.widget.battle.player1.name);
      } else if (value == 1) {
        setBattleData(state.widget.battle.player2.name);
      }
      testProvider.setIsBattleSelected(true);
    } else {
      testProvider.setIsBattleSelected(false);
    }

    focused = value;
    notifyListeners();
  }

  void setBattleData(String id) {
    battleProvider.setBattleData(idx: state.widget.index, id: id);
  }

  Future onPanUpdate(DragUpdateDetails details) async {
    if (state.widget.battle.winId.isNotEmpty) return;
    if (!_animation.isAnimating) {
      if (details.delta.dx < -2) {
        await startRightAnimation();
      } else if (details.delta.dx > 2) {
        await startLeftAnimation();
      }
    }

    notifyListeners();
  }

  Future startLeftAnimation() async {
    if (!_animation.isAnimating) {
      if (focused == 0) return;
      _animation.reset();
      setupLeftAnimation();
      setFocused(0);
      await _animation.forward();
      HapticFeedback.lightImpact();
    }
  }

  Future startRightAnimation() async {
    if (!_animation.isAnimating) {
      if (focused == 1) return;
      _animation.reset();
      setupRightAnimation();
      setFocused(1);
      await _animation.forward();
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _initSetting() {
    BattleModel battle = state.widget.battle;
    _animation = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: state as TickerProvider,
    );
    if (battle.player1.name == battle.winId) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        testProvider.setIsBattleSelected(true);
      });
      selectedLeft();
    } else if (battle.player2.name == battle.winId) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        testProvider.setIsBattleSelected(true);
      });
      selectedRight();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        testProvider.setIsBattleSelected(false);
      });
      setupLeftAnimation();
    }
  }

  BattleItem2Provider(this.state) {
    testProvider = Provider.of<TestProvider>(state.context);
    battleProvider = Provider.of<BattleTest2Provider>(state.context);

    _initSetting();
  }

  void selectedLeft() {
    focused = 0;
    notifyListeners();
    scaleAnimationA = Tween<double>(begin: 1.5, end: 1.5).animate(_animation);
    scaleAnimationB = Tween<double>(begin: 1.0, end: 1.0).animate(_animation);
    positionA =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
            .animate(_animation);
    positionB =
        Tween<Offset>(begin: const Offset(.6, 0), end: const Offset(.6, 0))
            .animate(_animation);
  }

  void selectedRight() {
    focused = 1;
    notifyListeners();
    scaleAnimationA = Tween<double>(begin: 1.0, end: 1.0).animate(_animation);
    scaleAnimationB = Tween<double>(begin: 1.5, end: 1.5).animate(_animation);
    positionA =
        Tween<Offset>(begin: const Offset(-.6, 0), end: const Offset(-.6, .0))
            .animate(_animation);
    positionB =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
            .animate(_animation);
  }

  void setupLeftAnimation() {
    scaleAnimationA = Tween<double>(begin: 1.0, end: 1.5).animate(_animation);
    scaleAnimationB = Tween<double>(begin: 1.0, end: 1.0).animate(_animation);
    positionA =
        Tween<Offset>(begin: const Offset(-.6, 0), end: const Offset(0, 0))
            .animate(_animation);
    positionB =
        Tween<Offset>(begin: const Offset(.6, 0), end: const Offset(.6, .0))
            .animate(_animation);
  }

  void setupRightAnimation() {
    scaleAnimationA = Tween<double>(begin: 1.0, end: 1.0).animate(_animation);
    scaleAnimationB = Tween<double>(begin: 1.0, end: 1.5).animate(_animation);
    positionA =
        Tween<Offset>(begin: const Offset(-.6, 0), end: const Offset(-.6, .0))
            .animate(_animation);
    positionB =
        Tween<Offset>(begin: const Offset(.6, 0), end: const Offset(0, 0))
            .animate(_animation);
  }
}
