import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef _OnLongPressStartHandler = void Function(LongPressStartDetails details);
typedef _OnLongPressMoveUpdateHandler = void Function(
    LongPressMoveUpdateDetails details);
typedef _OnLongPressEndHandler = void Function(LongPressEndDetails details);
typedef _OnHorizontalDragEndHandler = void Function(DragEndDetails details);

class CustomLongPress extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressCancel;
  final VoidCallback? onLongPressUp;
  final _OnLongPressStartHandler? onLongPressStart;
  final _OnLongPressMoveUpdateHandler? onLongPressMoveUpdate;
  final _OnLongPressEndHandler? onLongPressEnd;
  final _OnHorizontalDragEndHandler? onHorizontalDragEnd;
  final Widget? child;
  const CustomLongPress({
    super.key,
    required this.duration,
    this.onLongPress,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onHorizontalDragEnd,
    this.child,
  });

  @override
  State<CustomLongPress> createState() => _CustomLongPressState();
}

class _CustomLongPressState extends State<CustomLongPress> {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: <Type, GestureRecognizerFactory>{
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(duration: widget.duration),
          (instance) {
            instance
              ..onLongPress = widget.onLongPress
              ..onLongPressCancel = widget.onLongPressCancel
              ..onLongPressUp = widget.onLongPressUp
              ..onLongPressStart = widget.onLongPressStart
              ..onLongPressMoveUpdate = widget.onLongPressMoveUpdate
              ..onLongPressEnd = widget.onLongPressEnd;
          },
        ),
        HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            HorizontalDragGestureRecognizer>(
          () => HorizontalDragGestureRecognizer(),
          (instance) {
            instance..onEnd = widget.onHorizontalDragEnd;
          },
        ),
      },
      child: widget.child,
    );
  }
}
