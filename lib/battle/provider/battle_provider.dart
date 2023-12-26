import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_setting_test/model/battle.dart';

class BattleProvider with ChangeNotifier {
  State state;

  List battleDataList = [];
  List<BattleModel> battleDatas = [];

  late PageController pageController;

  Future generateBattleModel() async {
    final jsonContent = await rootBundle.loadString('assets/json/battle.json');
    List jsonData = jsonDecode(jsonContent);

    battleDatas = [...jsonData.map((e) => BattleModel.fromJson(e)).toList()];
    notifyListeners();
  }

  setBattleData({required String id, required int index}) {
    battleDatas[index].winId = id;
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

  BattleProvider(this.state) {
    pageController = PageController();
    generateBattleModel();
  }
}
