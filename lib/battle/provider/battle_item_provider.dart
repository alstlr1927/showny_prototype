import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_setting_test/battle/battle_test.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BattleItemProvider with ChangeNotifier {
  State<BattleItem> state;

  Offset startPosition = Offset.zero;
  Offset movePosition = Offset.zero;

  double diameter = 130.0;
  double moveDiameter = 70.0;

  bool isSelectMode = false;
  int? focused;
  double standardPosition = 0.0;
  Duration longPressDuration = const Duration(milliseconds: 150);

  void setSelected({required int value}) {
    if (focused == value) return;
    focused = value;
    HapticFeedback.lightImpact();
  }

  void setMovePosition(Offset value) {
    // 현재 좌표 값 value.dx, value.dy
    // 기준 좌표 값 startPosition.dx, startPosition.dy
    // 반지름 : diameter / 2
    double dx = value.dx - startPosition.dx;
    double dy = value.dy - startPosition.dy;

    double distance = sqrt(dx * dx + dy * dy);
    if (distance > diameter / 2 - moveDiameter / 2) {
      double angle = atan2(dy, dx);
      dx = cos(angle) * (diameter / 2 - moveDiameter / 2);
      dy = sin(angle) * (diameter / 2 - moveDiameter / 2);
      movePosition = Offset(startPosition.dx + dx, startPosition.dy + dy);
    } else {
      movePosition = value;
    }
  }

  void onLongPress() {
    isSelectMode = true;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void onLongPressStart(LongPressStartDetails details) {
    standardPosition = details.localPosition.dx;
    startPosition = Offset(details.localPosition.dx, details.localPosition.dy);
    movePosition = Offset(details.localPosition.dx, details.localPosition.dy);

    notifyListeners();
  }

  void onLongPressCancel() {
    isSelectMode = false;
    notifyListeners();
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    setMovePosition(Offset(details.localPosition.dx, details.localPosition.dy));

    if (details.localPosition.dx < standardPosition - 10) {
      setSelected(value: 0);
      // standardPosition = details.localPosition.dy;
    } else if (details.localPosition.dx > standardPosition + 10) {
      setSelected(value: 1);
      // standardPosition = details.localPosition.dy;
    }
    notifyListeners();
  }

  void onLongPressEnd(LongPressEndDetails details) {
    if (focused == 0) {
      Fluttertoast.showToast(
        msg: 'Up 하셨습니다!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(.7),
        textColor: Colors.white,
        fontSize: 16,
      );
      state.widget.onSelect?.call(
        id: state.widget.battle.player1.name,
        index: state.widget.index,
      );
    } else if (focused == 1) {
      Fluttertoast.showToast(
        msg: 'Down 하셨습니다!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(.7),
        textColor: Colors.white,
        fontSize: 16,
      );
      state.widget.onSelect?.call(
        id: state.widget.battle.player2.name,
        index: state.widget.index,
      );
    }

    focused = null;
    standardPosition = 0.0;
    notifyListeners();
  }

  void onLongPressUp() {
    isSelectMode = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  BattleItemProvider(this.state);
}
