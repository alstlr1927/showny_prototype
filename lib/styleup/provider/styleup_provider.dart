import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_setting_test/model/styleup.dart';

class StyleUpProvider with ChangeNotifier {
  State state;

  List<StyleUpModel> styleUpDatas = [];

  List<List<String>> imageList2 = [
    ['1.jpg', '2.jpg', '3.jpg', '4.jpg'],
    ['5.jpg'],
    ['9.jpg', '10.jpg', '11.jpg', '12.jpg'],
    ['13.jpg', '14.jpg', '15.jpg', '16.jpg'],
    ['5.jpg'],
  ];

  Future generateBattleModel() async {
    final jsonContent = await rootBundle.loadString('assets/json/styleup.json');
    List jsonData = jsonDecode(jsonContent);

    styleUpDatas = [...jsonData.map((e) => StyleUpModel.fromJson(e)).toList()];
    print(styleUpDatas);
    notifyListeners();
  }

  PageController pageController = PageController();

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  StyleUpProvider(this.state) {
    generateBattleModel();
  }
}
