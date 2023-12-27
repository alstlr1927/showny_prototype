import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle2/provider/battle_test2_provider.dart';
import 'package:flutter_setting_test/battle2/widgets/battle_item2.dart';
import 'package:flutter_setting_test/comm/scroll_physics/custom_page_view_scroll_physics.dart';
import 'package:provider/provider.dart';

class BattleTest2 extends StatefulWidget {
  const BattleTest2({
    super.key,
  });

  @override
  State<BattleTest2> createState() => _BattleTest2State();
}

class _BattleTest2State extends State<BattleTest2> {
  late BattleTest2Provider provider;

  @override
  void initState() {
    provider = BattleTest2Provider(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<BattleTest2Provider>.value(
      value: provider,
      builder: (context, child) {
        return Consumer<BattleTest2Provider>(builder: (ctx, prov, child) {
          return PageView(
            physics: const CustomPageViewScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: prov.pageController,
            children: List.generate(
              prov.battleDatas.length,
              (index) => BattleItem2(
                battle: prov.battleDatas[index],
                index: index,
                size: size,
              ),
            ),
          );
        });
      },
    );
  }
}
