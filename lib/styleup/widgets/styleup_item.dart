import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle/widgets/back_blur.dart';
import 'package:flutter_setting_test/comm/gesture_detector/custom_gesture_detector.dart';
import 'package:flutter_setting_test/model/styleup.dart';
import 'package:flutter_setting_test/styleup/provider/styleup_item_provider.dart';
import 'package:flutter_setting_test/styleup/widgets/styleup_photo.dart';
import 'package:flutter_setting_test/styleup/widgets/styleup_video.dart';
import 'package:provider/provider.dart';

class StyleUpItem extends StatefulWidget {
  final List<String> imgList;
  final StyleUpModel styleUp;
  // final PageController pController;
  final VoidCallback? onSelect;
  const StyleUpItem({
    Key? key,
    required this.imgList,
    required this.styleUp,
    // required this.pController,
    this.onSelect,
  }) : super(key: key);

  @override
  State<StyleUpItem> createState() => _StyleUpItemState();
}

class _StyleUpItemState extends State<StyleUpItem> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          StyleUpItemProvider(this, totalImgCnt: widget.imgList.length),
      builder: (context, _) {
        return Consumer<StyleUpItemProvider>(builder: (ctx, prov, child) {
          return LayoutBuilder(
            builder: (context, layout) {
              return Stack(
                children: <Widget>[
                  _buildStyleUP(prov, layout),
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          if (prov.isSelectMode) ...{
                            _buildSelectArea(
                              areaIdx: 1,
                              selected: prov.selected,
                              type: 'UP',
                            ),
                            _buildSelectArea(
                              areaIdx: 2,
                              selected: prov.selected,
                              type: 'DOWN',
                            ),
                          },
                        ],
                      ),
                      if (prov.isSelectMode &&
                          prov.startPosition != Offset.zero) ...{
                        _virtualPadArea(prov),
                        _virtualPad(prov),
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

  Widget _buildStyleUP(StyleUpItemProvider prov, BoxConstraints layout) {
    return Stack(
      children: [
        if (widget.styleUp.type == 'image') ...{
          BackBlurWidget2(
            width: 0,
            height: 0,
            image1: widget.styleUp.imageList.first,
          ),
        },
        SafeArea(
          bottom: false,
          top: widget.styleUp.type == 'image' ? true : false,
          child: CustomLongPress(
            duration: prov.longPressDuration,
            onLongPress: prov.onLongPress,
            onLongPressStart: prov.onLongPressStart,
            onLongPressCancel: prov.onLongPressCancel,
            onLongPressMoveUpdate: prov.onLongPressMoveUpdate,
            onLongPressEnd: prov.onLongPressEnd,
            onLongPressUp: prov.onLongPressUp,
            child: widget.styleUp.type == 'image'
                ? Column(
                    children: [
                      StyleUpImageItem(imageList: widget.styleUp.imageList),
                      _buildDescription(),
                    ],
                  )
                : Stack(
                    children: [
                      StyleUpVideoItem(videoPath: widget.styleUp.video),
                      _buildDescription(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset(
                  'assets/images/1.jpg',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.styleUp.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 56,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xff5900FF),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(
            height: 70,
            child: Text(
              '더많은 스타일링은\n프로필을 확인해 주세요 :-)\nasdfasdfasdfasdfasdfaasdfasdfasdfasdfasdfsfasdf',
              maxLines: 3,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildBottomBanner(),
        ],
      ),
    );
  }

  Widget _buildSelectArea(
      {required int selected, required String type, required int areaIdx}) {
    bool isSelect = selected == areaIdx;
    TextStyle selectedStyle = const TextStyle(
        fontSize: 44, color: Colors.white, fontWeight: FontWeight.w800);
    TextStyle unSelectedStyle = const TextStyle(
        fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold);
    return Flexible(
      flex: 1,
      child: Container(
        color: Colors.black.withOpacity(isSelect ? .3 : .6),
        child: Center(
          child: Text(
            type,
            style: isSelect ? selectedStyle : unSelectedStyle,
          ),
        ),
      ),
    );
  }

  Widget _virtualPadArea(StyleUpItemProvider prov) {
    return Positioned(
      top: prov.startPosition.dy - (prov.virtualPadAreaDiameter / 2),
      left: prov.startPosition.dx - (prov.virtualPadAreaDiameter / 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: prov.virtualPadAreaDiameter,
        height: prov.virtualPadAreaDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: prov.selected != 0
              ? Colors.white.withOpacity(.6)
              : Colors.white.withOpacity(.3),
        ),
      ),
    );
  }

  Widget _virtualPad(StyleUpItemProvider prov) {
    return AnimatedPositioned(
      duration: Duration.zero,
      top: prov.movePosition.dy - (prov.movePadDiameter / 2),
      left: prov.movePosition.dx - (prov.movePadDiameter / 2),
      child: Container(
        width: prov.movePadDiameter,
        height: prov.movePadDiameter,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          // margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
