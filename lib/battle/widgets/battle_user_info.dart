import 'package:flutter/material.dart';
import 'package:flutter_setting_test/model/battle.dart';

class BattleUserInfo extends StatelessWidget {
  final double width;
  final double height;
  final BattleModel battleInfo;
  const BattleUserInfo({
    super.key,
    required this.width,
    required this.height,
    required this.battleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only(top: width + ((height - width) / 2) - 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              // win id 가 존재하면서 내가 아닐때
              bool isHide = battleInfo.winId != battleInfo.player1.name &&
                  battleInfo.winId.isNotEmpty;
              return Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isHide) ...{
                          _playerChip(
                            player: battleInfo.player1,
                            winId: battleInfo.winId,
                          ),
                        },
                      ],
                    ),
                  ],
                ),
              );
            }),
            Builder(builder: (context) {
              bool isHide = battleInfo.winId != battleInfo.player2.name &&
                  battleInfo.winId.isNotEmpty;
              return Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isHide) ...{
                      _playerChip(
                        player: battleInfo.player2,
                        winId: battleInfo.winId,
                      ),
                    },
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _playerChip({required Player player, required String winId}) {
    return Container(
      width: 140,
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _profileImage(player.image),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    player.name + 'dafsdfasdfasdf',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),
          if (player.name == winId) ...{
            const SizedBox(height: 8),
            ProgressBar(),
          },
        ],
      ),
    );
  }

  Widget _profileImage(String imagePath) {
    return SizedBox(
      width: 24,
      height: 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.asset(
          'assets/images/$imagePath',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double x = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          x = 97;
          setState(() {});
        },
      );
    });

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: x,
      height: 27,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
