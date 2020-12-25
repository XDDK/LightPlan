import 'dart:async';

import 'package:flutter/material.dart';

class TreeTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TreeTimerStateful();
  }
}

class _TreeTimerStateful extends State<TreeTimer> {
  Stream<Duration> remainingTime;

  void startCountdown() {
    DateTime endOfYear = DateTime(DateTime.now().year, 12, 31, 24, 59, 59);
    print(endOfYear);
    int countDownTime = endOfYear.millisecondsSinceEpoch;

    var controller = StreamController<Duration>();
    Timer.periodic(Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      controller.add(Duration(milliseconds: countDownTime - now));
    });
    this.remainingTime = controller.stream;
  }

  @override
  void initState() {
    super.initState();
    this.startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: this.remainingTime,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var timeDiff = snapshot.data;
          String dateString = formatToDate(timeDiff);
          return Container(
            child: Text(
              dateString,
              style: TextStyle(color: Colors.blue),
            ),
            padding: EdgeInsets.all(10),
          );
        },
      ),
    );
  }

  String formatToDate(Duration duration) {
    //TODO prettier
    return '${duration.inDays}:${duration.inHours % 24}:${duration.inMinutes % 60}:${duration.inSeconds % 60}';
  }
}
