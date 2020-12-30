import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  CardContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      stepWidth: 200,
      child: Container(
        child: child,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}
