import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle/widgets/back_blur.dart';
import 'package:flutter_setting_test/battle2/provider/battle_item2_provider.dart';
import 'package:flutter_setting_test/battle2/widgets/battle_user.dart';
import 'package:flutter_setting_test/model/battle.dart';
import 'package:provider/provider.dart';

typedef _SetBattleData = void Function({required int idx, required String id});

class BattleItem2 extends StatefulWidget {
  final BattleModel battle;
  final int index;
  final Size size;
  final _SetBattleData setBattleData;
  const BattleItem2({
    super.key,
    required this.battle,
    required this.index,
    required this.size,
    required this.setBattleData,
  });

  @override
  State<BattleItem2> createState() => _BattleItem2State();
}

class _BattleItem2State extends State<BattleItem2>
    with TickerProviderStateMixin {
  double defaultImgWidth = 160;
  double imgRatio = 9 / 16;
  Duration aniDuration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    defaultImgWidth = widget.size.width * .41;
    return ChangeNotifierProvider<BattleItem2Provider>(
        create: (_) => BattleItem2Provider(this),
        builder: (context, _) {
          BattleItem2Provider provider =
              Provider.of<BattleItem2Provider>(context, listen: false);
          return Consumer<BattleItem2Provider>(builder: (ctx, prov, child) {
            return GestureDetector(
              onPanUpdate: provider.onPanUpdate,
              onTapUp: (details) {
                if (widget.battle.winId.isNotEmpty) return;
                if (details.localPosition.dx < widget.size.width / 2) {
                  provider.startLeftAnimation();
                } else {
                  provider.startRightAnimation();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BackBlurWidget(
                    width: widget.size.width,
                    height: double.infinity,
                    image1: widget.battle.player1.image,
                    image2: widget.battle.player2.image,
                  ),
                  BattleUser.left(
                      player: widget.battle.player1,
                      defaultImgWidth: defaultImgWidth,
                      winId: widget.battle.winId),
                  BattleUser.right(
                      player: widget.battle.player2,
                      defaultImgWidth: defaultImgWidth,
                      winId: widget.battle.winId),
                  if (provider.focused == 0) ...{
                    BattleUser.left(
                        player: widget.battle.player1,
                        defaultImgWidth: defaultImgWidth,
                        winId: widget.battle.winId),
                  },
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildBattleListBtn(),
                      _buildBottomBanner(),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget _buildBattleListBtn() {
    return Row(
      children: [
        const Spacer(),
        CupertinoButton(
          onPressed: () {},
          child: const Row(
            children: [
              Text(
                '배틀리스트',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 10,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildBottomBanner() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          padding: const EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.4),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset(
                  'assets/images/1.jpg',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CIDER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '솔리드 컷아웃 하이웨스트 와이드 레그 팬츠',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CupertinoButton(
                onPressed: () {},
                child: const Text(
                  '더보기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
