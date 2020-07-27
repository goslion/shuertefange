import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:setfg/BetProvider.dart';

class MyProvider extends ChangeNotifier {
  int count;
  List<int> data = List<int>();
  List<int> cur = List<int>();
  List<int> correct = List<int>();
  List<AnimationController> controllers = List<AnimationController>();
  List<Animation<Color>> animations = List<Animation<Color>>();
  int totalCell;
  Timer timer;
  double totalTime;
  bool isStart;
  int level;
  double fontSize;
  double padIn;
  int tapTimes;
  BetProvider betProvider;

  MyProvider() {
    // prefs = getPrefs();
    betProvider = BetProvider();
    level = 4;
    count = level * level;
    totalCell = count;
    isStart = false;
    totalTime = 0;
    fontSize = 24;
    padIn = 30;
    tapTimes = 0;
    List.generate(count, (index) => {data.add(index + 1)});
    correct = List.from(data);
    data.shuffle();
    timer = Timer(Duration(milliseconds: 100), record);
  }

  record() {
    if (isStart) {
      totalTime += 0.1;
      totalTime = totalTime;
      notifyListeners();
    } else {
      showInitTost();
    }
  }

  tapStart() {
    if (!isStart) {
      timer = Timer.periodic(Duration(milliseconds: 100), (_) {
        record();
      });
      isStart = true;
    } else {
      timer.cancel();
      isStart = false;
    }
    notifyListeners();
  }

  paly() {
    if (!isStart) {
      tapStart();
    }
  }

  isCorrect(i) {
    bool isCorrec = false;
    int last = cur.length > 0 ? cur.last : 0;
    int current = data[i];

    if (current - 1 == last) {
      isCorrec = true;
    }
    return isCorrec;
  }

  isRealOk(i) {
    bool isCorrec = false;
    if (tapTimes < totalCell) {
      int current = data[i];
      int correctNum = correct[tapTimes];
      if (correctNum == current) {
        isCorrec = true;
        tapTimes += 1;
      }
    }
    return isCorrec;
  }

  isEnd(i) {
    bool isEnd = false;
    if (cur.length == totalCell && data[i] == totalCell) {
      isEnd = true;
    }
    return isEnd;
  }

  toGreen(i) {
    animations[i] = ColorTween(begin: Colors.white, end: Colors.green)
        .animate(controllers[i]..addListener(() {}));
    notifyListeners();
  }

  toRed(i) {
    animations[i] = ColorTween(begin: Colors.white, end: Colors.redAccent)
        .animate(controllers[i]..addListener(() {}));
    notifyListeners();
  }

  tapCell(i) {
    paly();
    if (isRealOk(i)) {
      toGreen(i);
      cur.add(data[i]);
    } else {
      showTipTost();
      toRed(i);
    }
    if (isEnd(i)) {
      timer.cancel();
      showSuccessTost();
      betProvider.setLevelTotalTime(level.toString(), totalTime.toString());
    }
    controllers[i].forward(from: 0).then((_) => controllers[i].reverse());
    notifyListeners();
  }

  showSuccessTost() {
    Fluttertoast.showToast(
        msg: "恭喜,本次用时${totalTime.toStringAsFixed(1)}秒!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 24.0);
  }

  showInitTost() {
    Fluttertoast.showToast(
        msg: "正在初始化......",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 20.0);
  }

  showFriendTost() {
    Fluttertoast.showToast(
        msg: "已经是最简单的啦!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 24.0);
  }

  showMaxTost() {
    Fluttertoast.showToast(
        msg: "这已经是人类的极限了!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 24.0);
  }

  showTipTost() {
    Fluttertoast.showToast(
        msg: "顺次点击数字完成挑战!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 20.0);
  }

  reStart() {
    if (isStart) {
      timer.cancel();
    }
    isStart = false;
    tapTimes = 0;
    totalTime = 0;
    reBuild(count);
    notifyListeners();
  }

  nextLevel() {
    if (timer == null) {
      // print("......");
    } else {
      level += 1;
      fontSize -= 2;
      padIn -= 4;
      count = level * level;
      totalCell = count;
      isStart = false;
      tapTimes = 0;
      timer.cancel();
      totalTime = 0;
      reBuild(count);
    }
  }

  previousLevel() {
    if (isStart) {
      timer.cancel();
    }
    level -= 1;
    fontSize += 2;
    padIn += 4;
    count = level * level;
    totalCell = count;
    isStart = false;
    tapTimes = 0;
    timer.cancel();
    totalTime = 0;
    reBuild(count);
  }

  reBuild(count) {
    data = List<int>();
    cur = List<int>();
    List.generate(count, (index) => {data.add(index + 1)});
    correct = List.from(data);
    data.shuffle();
    notifyListeners();
  }
}
