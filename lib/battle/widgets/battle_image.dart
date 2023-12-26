import 'package:flutter/material.dart';
import 'package:flutter_setting_test/model/battle.dart';

class BattleImage extends StatefulWidget {
  final int? idx;
  final double width;
  final BattleModel battleInfo;
  const BattleImage({
    super.key,
    required this.width,
    required this.battleInfo,
    this.idx,
  });

  @override
  State<BattleImage> createState() => _BattleImageState();
}

class _BattleImageState extends State<BattleImage> {
  @override
  Widget build(BuildContext context) {
    Player player1 = widget.battleInfo.player1;
    Player player2 = widget.battleInfo.player2;
    String winId = widget.battleInfo.winId;
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: widget.width / 2 * 1,
            height: widget.width * 1,
            child: Image.asset(
              'assets/images/${widget.battleInfo.player1.image}',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: widget.width / 2 * 1,
            height: widget.width * 1,
            child: Image.asset(
              'assets/images/${widget.battleInfo.player2.image}',
              fit: BoxFit.cover,
            ),
          ),
        ),
        IndexedStack(
          index: winId == player1.name ? 0 : 1,
          children: [
            Builder(builder: (context) {
              bool isWin = winId == player1.name;
              return Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isWin ? widget.width / 2 * 1.2 : widget.width / 2,
                  height: isWin ? widget.width * 1.2 : widget.width,
                  child: Image.asset(
                    'assets/images/${player1.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
            Builder(builder: (context) {
              bool isWin = winId == player2.name;
              return Align(
                alignment: Alignment.centerRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isWin ? widget.width / 2 * 1.2 : widget.width / 2,
                  height: isWin ? widget.width * 1.2 : widget.width,
                  child: Image.asset(
                    'assets/images/${player2.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
