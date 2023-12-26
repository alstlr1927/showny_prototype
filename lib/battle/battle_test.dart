import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle/provider/battle_item_provider.dart';
import 'package:flutter_setting_test/battle/provider/battle_provider.dart';
import 'package:flutter_setting_test/battle/widgets/back_blur.dart';
import 'package:flutter_setting_test/battle/widgets/battle_image.dart';
import 'package:flutter_setting_test/battle/widgets/battle_user_info.dart';
import 'package:flutter_setting_test/comm/gesture_detector/custom_gesture_detector.dart';
import 'package:flutter_setting_test/model/battle.dart';
import 'package:provider/provider.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  late BattleProvider provider;

  @override
  void initState() {
    provider = BattleProvider(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BattleProvider>.value(
      value: provider,
      builder: (context, _) {
        return Consumer<BattleProvider>(
          builder: (ctx, prov, child) {
            return PageView(
              controller: prov.pageController,
              scrollDirection: Axis.vertical,
              children: List.generate(
                prov.battleDatas.length,
                (index) => BattleItem(
                  battle: prov.battleDatas[index],
                  onSelect: prov.setBattleData,
                  index: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

typedef _OnSelect = void Function({required String id, required int index});

class BattleItem extends StatefulWidget {
  final int index;
  final BattleModel battle;
  final _OnSelect? onSelect;
  const BattleItem({
    super.key,
    required this.battle,
    this.onSelect,
    required this.index,
  });

  @override
  State<BattleItem> createState() => _BattleItemState();
}

class _BattleItemState extends State<BattleItem> {
  @override
  Widget build(BuildContext context) {
    Player player1 = widget.battle.player1;
    Player player2 = widget.battle.player2;
    return ChangeNotifierProvider<BattleItemProvider>(
      create: (_) => BattleItemProvider(this),
      builder: (context, _) {
        BattleItemProvider itemProv =
            Provider.of<BattleItemProvider>(context, listen: false);
        return Consumer<BattleItemProvider>(builder: (ctx, prov, child) {
          return LayoutBuilder(
            builder: (context, layout) {
              return Stack(
                children: <Widget>[
                  CustomLongPress(
                    duration: itemProv.longPressDuration,
                    onLongPress: itemProv.onLongPress,
                    onLongPressStart: itemProv.onLongPressStart,
                    onLongPressCancel: itemProv.onLongPressCancel,
                    onLongPressMoveUpdate: itemProv.onLongPressMoveUpdate,
                    onLongPressEnd: itemProv.onLongPressEnd,
                    onLongPressUp: itemProv.onLongPressUp,
                    child: SizedBox(
                      width: layout.maxWidth,
                      height: layout.maxHeight,
                      child: Stack(
                        children: [
                          BackBlurWidget(
                            width: layout.maxWidth,
                            height: layout.maxHeight,
                            image1: player1.image,
                            image2: player2.image,
                          ),
                          BattleImage(
                            width: layout.maxWidth,
                            battleInfo: widget.battle,
                            idx: prov.focused,
                          ),
                          BattleUserInfo(
                            width: layout.maxWidth,
                            height: layout.maxHeight,
                            battleInfo: widget.battle,
                          ),
                          // if (!prov.isSelectMode &&
                          //     widget.battle.winId.isNotEmpty) ...{
                          //   Align(
                          //     alignment: widget.battle.winId == player1.name
                          //         ? Alignment.centerRight
                          //         : Alignment.centerLeft,
                          //     child: Container(
                          //       width: layout.maxWidth / 2,
                          //       color: Colors.black.withOpacity(.8),
                          //     ),
                          //   ),
                          // },
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Row(
                        children: <Widget>[
                          if (prov.isSelectMode) ...{
                            Builder(
                              builder: (context) {
                                bool isFocused = prov.focused == 0;
                                return Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.black
                                        .withOpacity(isFocused ? .3 : .6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: layout.maxWidth,
                                          alignment: Alignment.bottomCenter,
                                          padding:
                                              const EdgeInsets.only(bottom: 50),
                                          child: Text(
                                            'LEFT',
                                            style: TextStyle(
                                              fontSize: isFocused ? 26 : 20,
                                              color: Colors.white,
                                              fontWeight: isFocused
                                                  ? FontWeight.w800
                                                  : FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Builder(
                              builder: (context) {
                                bool isFocused = prov.focused == 1;
                                return Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.black
                                        .withOpacity(isFocused ? .3 : .6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: layout.maxWidth,
                                          alignment: Alignment.bottomCenter,
                                          padding:
                                              const EdgeInsets.only(bottom: 50),
                                          child: Text(
                                            'RIGHT',
                                            style: TextStyle(
                                              fontSize: isFocused ? 26 : 20,
                                              color: Colors.white,
                                              fontWeight: isFocused
                                                  ? FontWeight.w800
                                                  : FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          },
                        ],
                      ),
                      if (prov.isSelectMode &&
                          prov.startPosition != Offset.zero) ...{
                        Positioned(
                          top: prov.startPosition.dy - (prov.diameter / 2),
                          left: prov.startPosition.dx - (prov.diameter / 2),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: prov.diameter,
                            height: prov.diameter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: prov.focused != 0
                                  ? Colors.white.withOpacity(.6)
                                  : Colors.white.withOpacity(.3),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration.zero,
                          top: prov.movePosition.dy - (prov.moveDiameter / 2),
                          left: prov.movePosition.dx - (prov.moveDiameter / 2),
                          child: Container(
                            width: prov.moveDiameter,
                            height: prov.moveDiameter,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }
}
