/*   
*    LightPlan is an open source app created with the intent of helping users keep track of tasks.
*    Copyright (C) 2020-2021 LightPlan Team
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program. If not, see https://www.gnu.org/licenses/.
*
*    Contact the authors at: contact@lightplanx.com
*/

import 'package:flutter/material.dart';

import '../widgets/my_container.dart';

class TutorialWidget extends StatefulWidget {
  final Function updatePreferences;

  TutorialWidget({@required this.updatePreferences});

  @override
  _TutorialWidgetState createState() => _TutorialWidgetState();
}

class _TutorialWidgetState extends State<TutorialWidget> {
  int currPage = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildTutorialPage(0),
                  _buildTutorialPage(1),
                  _buildTutorialPage(2),
                  _buildTutorialPage(3),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(true),
                _buildButton(false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(int page) {
    return Visibility(
      visible: currPage == page,
      child: MyContainer(
        color: Colors.grey[200],
        child: Image.asset('images/tutorial/p${currPage + 1}-min.png'),
      ),
    );
  }

  Widget _buildButton(bool isLeft) {
    if (isLeft && currPage == 0) return Container();
    return MyContainer(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      ripple: true,
      child: FittedBox(child: isLeft ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_forward_ios)),
      onTap: () {
        if (isLeft)
          goBack();
        else
          goForward();
      },
    );
  }

  void goBack() {
    if (currPage > 0) {
      setState(() {
        currPage--;
      });
    }
  }

  void goForward() {
    if (currPage < 4) {
      setState(() {
        currPage++;
      });
    }
    if (currPage == 4) {
      widget.updatePreferences(false);
    }
  }
}
