import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import '../styleup.dart';

class PageItemProvider with ChangeNotifier {
  State<PageItem> state;
  int totalImgCnt;

  int curIdx = 0;

  bool get hasNext => curIdx < totalImgCnt - 1;

  Offset startPosition = Offset.zero;
  Offset movePosition = Offset.zero;

  double diameter = 130.0;
  double moveDiameter = 70.0;

  bool isSelectMode = false;
  int selected = 0;
  double standardPosition = 0.0;
  Duration longPressDuration = const Duration(milliseconds: 100);

  void setCurIdx(int value) {
    curIdx = value;
    notifyListeners();
  }

  void setSelected({required int value}) {
    if (selected == value) return;
    selected = value;
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
    standardPosition = details.localPosition.dy;
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

    if (details.localPosition.dy < standardPosition - 10) {
      setSelected(value: 1);
      // standardPosition = details.localPosition.dy;
    } else if (details.localPosition.dy > standardPosition + 10) {
      setSelected(value: 2);
      // standardPosition = details.localPosition.dy;
    }
    notifyListeners();
  }

  void onLongPressEnd(LongPressEndDetails details) {
    if (selected == 1) {
      Fluttertoast.showToast(
        msg: 'Up 하셨습니다!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(.7),
        textColor: Colors.white,
        fontSize: 16,
      );
      state.widget.onSelect?.call();
    } else if (selected == 2) {
      Fluttertoast.showToast(
        msg: 'Down 하셨습니다!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(.7),
        textColor: Colors.white,
        fontSize: 16,
      );
      state.widget.onSelect?.call();
    }

    selected = 0;
    standardPosition = 0.0;
    notifyListeners();
  }

  void onLongPressUp() {
    isSelectMode = false;
    notifyListeners();
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy > 0) {
      if (state.widget.pController.page?.toInt() == 0) return;
      _animateToPage(state.widget.pController.page!.toInt() - 1);
    } else if (details.velocity.pixelsPerSecond.dy < 0) {
      _animateToPage(state.widget.pController.page!.toInt() + 1);
    }
  }

  void _animateToPage(int page) {
    state.widget.pController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200), // 애니메이션 속도 변경
      curve: Curves.easeOut, // 애니메이션 곡선 변경
    );
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

  PageItemProvider(this.state, this.totalImgCnt);
}
