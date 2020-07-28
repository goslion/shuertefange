import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setfg/BetProvider.dart';
import 'package:setfg/MyProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "舒尔特方格",
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (BuildContext context) {
              return MyProvider();
            }),
            ChangeNotifierProvider(create: (BuildContext context) {
              return BetProvider();
            })
          ],
          child: ShuCell(),
        ));
  }
}

class ShuCell extends StatefulWidget {
  ShuCell({Key key}) : super(key: key);

  @override
  _ShuCellState createState() => _ShuCellState();
}

class _ShuCellState extends State<ShuCell> with TickerProviderStateMixin {
  int count;
  List<int> data = List<int>();
  List<int> cur = List<int>();
  List<AnimationController> controllers = List<AnimationController>();
  List<Animation<Color>> animations = List<Animation<Color>>();
  MyProvider provider;
  // BetProvider betProvider;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    // BetProvider betProvider = Provider.of<BetProvider>(context);
    count = provider.count;
    List.generate(count, (index) {
      controllers.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)));
      animations.add(ColorTween(begin: Colors.white, end: Colors.white)
          .animate(controllers[index]
            ..addListener(() {
              setState(() {});
            })));
    });
    data = provider.data;
    provider.controllers = controllers;
    provider.animations = animations;
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              '舒尔特方格',
              style: TextStyle(fontSize: 36 * rpx, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey, shape: BoxShape.rectangle),
                margin: EdgeInsets.symmetric(
                    horizontal: 5 * rpx, vertical: 5 * rpx),
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * rpx, vertical: 5 * rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "当前:[${provider.level}X${provider.level}]关",
                      style: TextStyle(
                          fontSize: 24 * rpx,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    TimeRecorder()
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(color: Colors.black12),
                child: GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 5 * rpx),
                  crossAxisCount: provider.level,
                  children: List.generate(
                    count,
                    (index) => GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey[300]),
                          color: provider.animations[index].value,
                        ),
                        child: FlatButton(
                          // color: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              vertical: provider.padIn * rpx,
                              horizontal: provider.padIn * rpx),
                          onPressed: () {
                            provider.tapCell(index);
                          },
                          child: Text(
                            '${provider.data[index]}',
                            style: TextStyle(
                              fontSize: provider.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
                child: Container(
              decoration: BoxDecoration(shape: BoxShape.rectangle),
              margin: EdgeInsets.symmetric(
                horizontal: 5 * rpx,
                vertical: 5 * rpx,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.all(20 * rpx),
                    color: Colors.red,
                    child: Text(
                      "上一关",
                      style: TextStyle(
                          fontSize: 24 * rpx,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (provider.level > 4) {
                        provider.previousLevel();
                        setState(() {});
                      } else {
                        provider.showFriendTost();
                      }
                    },
                  )),
                  Expanded(
                    child: Container(
                      child: RaisedButton(
                        padding: EdgeInsets.all(20 * rpx),
                        color: Colors.indigo[400],
                        child: Text(
                          "重新挑战",
                          style: TextStyle(
                              fontSize: 24 * rpx,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          provider.reStart();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
            Flexible(
                child: Container(
              decoration: BoxDecoration(shape: BoxShape.rectangle),
              margin: EdgeInsets.symmetric(
                horizontal: 5 * rpx,
                vertical: 5 * rpx,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.all(20 * rpx),
                    color: Colors.green,
                    child: Text(
                      "下一关",
                      style: TextStyle(
                          fontSize: 24 * rpx,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (provider.level <= 5) {
                        provider.nextLevel();
                        setState(() {});
                      } else {
                        provider.showMaxTost();
                      }
                    },
                  )),
                  Expanded(
                    child: Container(
                      child: RaisedButton(
                        padding: EdgeInsets.all(20 * rpx),
                        color: Colors.brown,
                        child: Text(
                          "查看记录",
                          style: TextStyle(
                              fontSize: 24 * rpx,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          // betProvider.getBest();
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      MultiProvider(providers: [
                                        ChangeNotifierProvider(
                                            create: (BuildContext context) {
                                          return BetProvider();
                                        })
                                      ], child: Record())));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ));
  }
}

class TimeRecorder extends StatefulWidget {
  TimeRecorder({Key key}) : super(key: key);

  @override
  _TimeRecorderState createState() => _TimeRecorderState();
}

class _TimeRecorderState extends State<TimeRecorder> {
  Timer timer;
  double totalTime;

  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    return Text(
      "用时:${provider.totalTime.toStringAsFixed(1)}",
      style: TextStyle(
          fontSize: 24 * rpx, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}

class Record extends StatefulWidget {
  Record({Key key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  String lv4Time;
  String lv5Time;
  String lv6Time;
  BetProvider betProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;

    BetProvider provider = Provider.of<BetProvider>(context);
    lv4Time = provider.leve4Time;
    lv5Time = provider.leve5Time;
    lv6Time = provider.leve6Time;
    // print(lv4Time);
    // print(provider.getBest());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                '最佳记录',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            )),
        body: Container(
          color: Colors.brown[300],
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10 * rpx),
                padding: EdgeInsets.symmetric(horizontal: 10 * rpx),
                decoration: BoxDecoration(color: Colors.brown[200]),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.star,
                                size: 36,
                                color: Colors.amber,
                              ),
                            ),
                            Container(
                              child: Text(
                                "4",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 36),
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "$lv4Time",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10 * rpx),
                padding: EdgeInsets.symmetric(horizontal: 10 * rpx),
                decoration: BoxDecoration(color: Colors.brown[200]),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.star,
                                size: 36,
                                color: Colors.amber,
                              ),
                            ),
                            Container(
                              child: Text(
                                "5",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 36),
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "$lv5Time",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10 * rpx),
                padding: EdgeInsets.symmetric(horizontal: 10 * rpx),
                decoration: BoxDecoration(color: Colors.brown[200]),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.star,
                                size: 36,
                                color: Colors.amber,
                              ),
                            ),
                            Container(
                              child: Text(
                                "6",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 36),
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "$lv6Time",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
