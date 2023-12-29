import 'package:flutter/material.dart';
import 'package:flutter_setting_test/comm/scroll_physics/custom_page_view_scroll_physics.dart';
import 'package:flutter_setting_test/styleup/provider/styleup_provider.dart';
import 'package:flutter_setting_test/styleup/widgets/styleup_item.dart';
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
              physics: const CustomPageViewScrollPhysics(),
              children: List.generate(
                prov.styleUpDatas.length,
                (index) => StyleUpItem(
                  imgList: prov.imageList2[index],
                  styleUp: prov.styleUpDatas[index],
                  // pController: prov.pageController,
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
