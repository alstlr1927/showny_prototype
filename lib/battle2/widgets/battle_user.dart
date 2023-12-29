import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle2/provider/battle_item2_provider.dart';
import 'package:flutter_setting_test/model/battle.dart';
import 'package:provider/provider.dart';

class BattleUser extends StatefulWidget {
  final Player player;
  final double defaultImgWidth;
  final String winId;
  final bool isLeft;
  const BattleUser.left({
    Key? key,
    required this.player,
    required this.defaultImgWidth,
    required this.winId,
  })  : isLeft = true,
        super(key: key);

  const BattleUser.right({
    Key? key,
    required this.player,
    required this.defaultImgWidth,
    required this.winId,
  })  : isLeft = false,
        super(key: key);

  @override
  State<BattleUser> createState() => _BattleUserState();
}

class _BattleUserState extends State<BattleUser> {
  final double imgRatio = 9 / 16;
  final Duration aniDuration = const Duration(milliseconds: 200);
  double rating = 0.0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    BattleItem2Provider prov =
        Provider.of<BattleItem2Provider>(context, listen: false);
    bool isFinished = widget.winId.isNotEmpty;
    bool isWin = widget.player.name == widget.winId;
    return SlideTransition(
      position: widget.isLeft ? prov.positionA : prov.positionB,
      child: ScaleTransition(
        scale: widget.isLeft ? prov.scaleAnimationA : prov.scaleAnimationB,
        child: SizedBox(
          width: widget.defaultImgWidth,
          height: widget.defaultImgWidth * (16 / 9),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: widget.defaultImgWidth,
                  height: widget.defaultImgWidth * (16 / 9),
                  child: Image.asset(
                    'assets/images/${widget.player.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSize(
                  duration: aniDuration,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black.withOpacity(.6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.asset(
                                  'assets/images/${widget.player.image}',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.player.name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isFinished && isWin) ...{
                          LayoutBuilder(
                            builder: (context, layout) {
                              WidgetsBinding.instance
                                  .addPersistentFrameCallback((timeStamp) {
                                rating = .78;
                                setState(() {});
                              });
                              return Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    width: layout.maxWidth * rating,
                                    height: 27,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff5900FF),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          const Color(0xff5900FF)
                                              .withOpacity(.3),
                                          const Color(0xff5900FF)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      rating == 0
                                          ? ''
                                          : '${getInteger(rating)}%',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: aniDuration,
                  width: widget.defaultImgWidth,
                  height: widget.defaultImgWidth * (16 / 9),
                  color: isFinished && !isWin
                      ? Colors.black.withOpacity(.4)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getInteger(double rate) {
    return (rate * 100.0).toInt();
  }
}
