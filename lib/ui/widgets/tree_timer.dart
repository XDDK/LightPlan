import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TreeTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TreeTimerStateful();
  }
}

class _TreeTimerStateful extends State<TreeTimer> {
  Stream<int> remainingTime;
  DateFormat countdownFormat = DateFormat("dd:HH:mm:ss");

  void startCountdown() {
    DateTime endOfYear = DateTime(DateTime.now().year, 12, 31, 23, 59, 59);
    print(endOfYear);
    int countDownTime = endOfYear.millisecondsSinceEpoch;

    // ignore: close_sinks
    var controller = StreamController<int>();
    Timer.periodic(Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      controller
          .add(Duration(milliseconds: countDownTime - now).inMilliseconds);
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
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //snapshot.data is time in milliseconds
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          String dateString = countdownFormat
              .format(DateTime.fromMillisecondsSinceEpoch(snapshot.data));
          return Container(
            child: Text(dateString),
            padding: EdgeInsets.all(10),
          );
        },
      ),
    );
  }
}
