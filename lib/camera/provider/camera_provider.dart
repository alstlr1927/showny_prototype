import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  State state;
  bool isLoad = true;

  Future _init() async {
    isLoad = false;
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

  CameraProvider(this.state) {
    _init();
  }
}
