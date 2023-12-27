import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_setting_test/model/battle.dart';

class BattleTest2Provider with ChangeNotifier {
  State state;

  List<BattleModel> battleDatas = [];

  late PageController pageController;

  Future generateBattleModel() async {
    final jsonContent = await rootBundle.loadString('assets/json/battle.json');
    List jsonData = jsonDecode(jsonContent);

    battleDatas = [...jsonData.map((e) => BattleModel.fromJson(e)).toList()];
    notifyListeners();
  }

  void setBattleData({required int idx, required String id}) {
    print('set battle data');
    battleDatas[idx].winId = id;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  BattleTest2Provider(this.state) {
    pageController = PageController();
    generateBattleModel();
  }
}
