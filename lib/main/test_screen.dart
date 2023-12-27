import 'package:flutter/material.dart';
import 'package:flutter_setting_test/battle/battle_test.dart';
import 'package:flutter_setting_test/battle2/battle_test2.dart';
import 'package:flutter_setting_test/main/provider/test_provider.dart';
import 'package:flutter_setting_test/styleup/styleup.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late TestProvider provider;

  @override
  void initState() {
    provider = TestProvider(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TestProvider>.value(
      value: provider,
      builder: (context, _) {
        return Consumer<TestProvider>(
          builder: (ctx, prov, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              body: Stack(
                children: [
                  PageView(
                    physics: prov.curPageIdx == 0
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    controller: prov.pageController,
                    onPageChanged: prov.setTab,
                    allowImplicitScrolling: true,
                    children: const [
                      StyleUp(),
                      BattleTest2(),
                    ],
                  ),
                  SafeArea(
                    child: TabBar(
                      controller: prov.tabController,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      labelPadding: const EdgeInsets.only(bottom: 3),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: const [
                        Text('스타일업'),
                        Text('배틀'),
                      ],
                      onTap: prov.setpage,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
