import 'package:flutter/material.dart';
import 'package:flutter_setting_test/comm/gesture_detector/custom_gesture_detector.dart';
import 'package:flutter_setting_test/styleup/provider/page_item_provider.dart';
import 'package:flutter_setting_test/styleup/provider/styleup_provider.dart';
import 'package:provider/provider.dart';

class StyleUp extends StatefulWidget {
  const StyleUp({super.key});

  @override
  State<StyleUp> createState() => _StyleUpState();
}

class _StyleUpState extends State<StyleUp> {
  late StyleUpProvider provider;

  @override
  void initState() {
    provider = StyleUpProvider(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StyleUpProvider>.value(
        value: provider,
        builder: (context, _) {
          return Consumer<StyleUpProvider>(builder: (ctx, prov, child) {
            return PageView(
              controller: prov.pageController,
              scrollDirection: Axis.vertical,
              // physics: const NeverScrollableScrollPhysics(),
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              children: List.generate(
                prov.imageList.length,
                (index) => PageItem(
                  imagePath: prov.imageList[index],
                  pController: prov.pageController,
                  onSelect: () {
                    prov.pageController.animateToPage(
                      index + 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
            );
          });
        });
  }
}

class PageItem extends StatefulWidget {
  final String imagePath;
  final VoidCallback? onSelect;
  final PageController pController;

  const PageItem({
    super.key,
    required this.imagePath,
    this.onSelect,
    required this.pController,
  });

  @override
  State<PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  late PageItemProvider provider;
  @override
  void initState() {
    provider = PageItemProvider(this);
    super.initState();
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageItemProvider>(
        create: (_) => PageItemProvider(this),
        builder: (context, _) {
          PageItemProvider itemProv =
              Provider.of<PageItemProvider>(context, listen: false);
          return LayoutBuilder(builder: (context, layout) {
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
                  // onHorizontalDragEnd: itemProv.onHorizontalDragEnd,
                  child: SizedBox(
                    width: layout.maxWidth,
                    height: layout.maxHeight,
                    child: Image.asset(
                      'assets/images/${widget.imagePath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Consumer<PageItemProvider>(
                  builder: (ctx, prov, child) {
                    return Stack(
                      children: [
                        Row(
                          children: <Widget>[
                            if (prov.isSelectMode) ...{
                              Flexible(
                                flex: 1,
                                child: prov.selected == 1
                                    ? Container(
                                        color: Colors.black.withOpacity(.3),
                                        child: const Center(
                                          child: Text(
                                            'UP',
                                            style: TextStyle(
                                              fontSize: 44,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.black.withOpacity(.6),
                                        child: const Center(
                                          child: Text(
                                            'UP',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                              Flexible(
                                flex: 1,
                                child: prov.selected == 2
                                    ? Container(
                                        color: Colors.black.withOpacity(.3),
                                        child: const Center(
                                          child: Text(
                                            'DOWN',
                                            style: TextStyle(
                                              fontSize: 44,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.black.withOpacity(.6),
                                        child: const Center(
                                          child: Text(
                                            'DOWN',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                color: prov.selected != 0
                                    ? Colors.white.withOpacity(.6)
                                    : Colors.white.withOpacity(.3),
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration.zero,
                            top: prov.movePosition.dy - (prov.moveDiameter / 2),
                            left:
                                prov.movePosition.dx - (prov.moveDiameter / 2),
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
                    );
                  },
                ),
              ],
            );
          });
        });
  }
}
