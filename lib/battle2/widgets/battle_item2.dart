import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle/widgets/back_blur.dart';
import 'package:flutter_setting_test/battle2/provider/battle_item2_provider.dart';
import 'package:flutter_setting_test/comm/gesture_detector/custom_gesture_detector.dart';
import 'package:flutter_setting_test/model/battle.dart';
import 'package:provider/provider.dart';

class BattleItem2 extends StatefulWidget {
  final BattleModel battle;
  const BattleItem2({
    super.key,
    required this.battle,
  });

  @override
  State<BattleItem2> createState() => _BattleItem2State();
}

class _BattleItem2State extends State<BattleItem2>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BattleItem2Provider>(
        create: (_) => BattleItem2Provider(this),
        builder: (context, _) {
          return Consumer<BattleItem2Provider>(builder: (ctx, prov, child) {
            return CustomLongPress(
              duration: prov.longPressDuration,
              onLongPress: prov.onLongPress,
              onLongPressCancel: prov.onLongPressCancel,
              onLongPressUp: prov.onLongPressUp,
              onLongPressEnd: prov.onLongPressEnd,
              onLongPressMoveUpdate: prov.onLongPressMoveUpdate,
              onLongPressStart: prov.onLongPressStart,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BackBlurWidget(
                    width: MediaQuery.of(ctx).size.width,
                    height: double.infinity,
                    image1: widget.battle.player1.image,
                    image2: widget.battle.player2.image,
                  ),
                  AnimatedScale(
                    scale: prov.isSelectMode ? 1.2 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: SlideTransition(
                      position: prov.positionA,
                      child: ScaleTransition(
                        scale: prov.scaleAnimationA,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 140,
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: Image.asset(
                                'assets/images/${widget.battle.player1.image}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    scale: prov.isSelectMode ? 1.2 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: SlideTransition(
                      position: prov.positionB,
                      child: ScaleTransition(
                        scale: prov.scaleAnimationB,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 140,
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: Image.asset(
                                'assets/images/${widget.battle.player2.image}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (prov.focused == 0) ...{
                    AnimatedScale(
                      scale: prov.isSelectMode ? 1.2 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: SlideTransition(
                        position: prov.positionA,
                        child: ScaleTransition(
                          scale: prov.scaleAnimationA,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 140,
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: Image.asset(
                                  'assets/images/${widget.battle.player1.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  }
                ],
              ),
            );
          });
        });
  }
}
