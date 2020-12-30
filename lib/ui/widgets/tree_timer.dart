import 'dart:async';

import 'package:flutter/material.dart';
import '../../tree_handler.dart';
import 'package:provider/provider.dart';

class TreeTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TreeTimerStateful();
  }
}

class _TreeTimerStateful extends State<TreeTimer> {
  TreeHandler treeHandler;
  Stream<Duration> remainingTime;
  Timer timer;

  void startCountdown() {
    int countDownTime;
    if (treeHandler.currentTask == null) {
      countDownTime = DateTime(DateTime.now().year, 12, 31, 24).millisecondsSinceEpoch;
    } else {
      countDownTime = treeHandler.currentTask.endDate;
    }
    countDownTime -= 100; // adjust time to be a little early

    // ignore: close_sinks
    var controller = StreamController<Duration>();
    if (timer != null) timer.cancel();

    int now = DateTime.now().millisecondsSinceEpoch;
    controller.add(Duration(milliseconds: countDownTime - now));

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      controller.add(Duration(milliseconds: countDownTime - now));
    });
    this.remainingTime = controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    this.treeHandler = context.watch<TreeHandler>();
    this.startCountdown();

    return Center(
      child: StreamBuilder(
        stream: this.remainingTime,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return dateWidgetBuilder(snapshot.data);
        },
      ),
    );
  }

  TextStyle customStyle(double fontSize) {
    return TextStyle(
      letterSpacing: 3.0,
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.bold
    );
  }

  Widget dateWidgetBuilder(Duration durationLeft) {
    if (durationLeft.isNegative) {
      return Column(
        children: [
          //Empty container used for formatting
          SizedBox(height: 10),

          Text(
            "Overdue by ${durationLeft.inDays.abs()} days...",
            textAlign: TextAlign.center,
            style: customStyle(30),
          ),

          Text(
            "Try until you make it!",
            textAlign: TextAlign.center,
            style: customStyle(15),
          ),

          Container(height: 10)
        ],
      );
    }

    String dateString = formatToDate(durationLeft);
    return Container(
      child: Text(
        dateString,
        style: TextStyle(
          letterSpacing: 3.0,
          color: Colors.black,
          fontSize: 35,
          fontFamily: 'dpcomic', //! - custom font 'digital-7' doesnt render on mobile web + it's licensed under Freeware home use only
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: EdgeInsets.all(10),
    );
  }

  String formatToDate(Duration duration) {
    String days = (duration.inDays).toString().padLeft(2, '0');
    String hours = (duration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$days:$hours:$minutes:$seconds';
  }
}
