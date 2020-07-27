import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BetProvider extends ChangeNotifier {
  String leve4Time;
  String leve5Time;
  String leve6Time;
  BetProvider() {
    leve4Time = "";
    leve5Time = "";
    leve6Time = "";
    init();
  }

  init() {
    getLevelTotalTime("4");
    getLevelTotalTime("5");
    getLevelTotalTime("6");
  }

  setLevelTotalTime(level, time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lasttime = prefs.get(level);
    if (lasttime == null) {
      await prefs.setString(level, time);
    } else if (double.parse(lasttime) > double.parse(time)) {
      await prefs.setString(level, time);
    }
  }

  getLevelTotalTime(String level) async {
    String bestTime = "0";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String time = prefs.get(level);
    if (time != null) {
      bestTime = double.parse(time).toStringAsFixed(3);
      if (level == "4") {
        leve4Time = bestTime;
      } else if (level == "5") {
        leve5Time = bestTime;
      } else {
        leve6Time = bestTime;
      }
      notifyListeners();
    }
  }
}
