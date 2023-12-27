import 'package:flutter/material.dart';
import 'package:flutter_setting_test/comm/scroll_physics/custom_page_view_scroll_physics.dart';

class TestProvider with ChangeNotifier {
  State state;
  late PageController pageController;
  late TabController tabController;

  int curPageIdx = 0;

  bool isBattleSelected = false;

  ScrollPhysics getPhysics() {
    if (curPageIdx == 0 || isBattleSelected) {
      return const CustomPageViewScrollPhysics();
    }
    return const NeverScrollableScrollPhysics();
  }

  void setIsBattleSelected(bool value) {
    isBattleSelected = value;
    print('setbattleselected : $value');
    notifyListeners();
  }

  void setpage(int value) {
    pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void setTab(int value) {
    tabController.animateTo(value,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    curPageIdx = value;
    notifyListeners();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  TestProvider(this.state) {
    pageController = PageController();
    pageController.addListener(() {
      if (pageController.page?.round() == 0 &&
          pageController.position.pixels < 0) {
        pageController.position.correctPixels(0);
      }
      if (pageController.page?.round() == 1 &&
          pageController.position.pixels >
              pageController.position.maxScrollExtent) {
        pageController.position
            .correctPixels(pageController.position.maxScrollExtent);
      }
    });

    tabController = TabController(length: 2, vsync: state as TickerProvider);
  }
}
