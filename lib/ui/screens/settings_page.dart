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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/my_container.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("")),
        body: SingleChildScrollView(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              _buildItem(
                Icons.info_outline,
                "About",
                RichText(
                  text: TextSpan(
                    text: '''
      This is an open-source project created by two passionate students. 
      Our aim is to provide people with a simple, free and open source planner for 
      any type of activity. Since it's open source, the project can be customized to 
      everybody's liking. If you are interested, the '''
                        .replaceAll("\n", "")
                        .replaceAll("      ", ""),
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "full source code can be found here",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () => launch("https://github.com/XDDK/LightPlan"),
                      ),
                      TextSpan(
                        text: "\n\nA web version of this app is also available online and ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "can be found here",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () => launch("https://lightplanx.com"),
                      ),
                    ],
                  ),
                ),
                context,
              ),
              Divider(thickness: 1),
              _buildItem(
                Icons.favorite_outline,
                "Support Us",
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_outline),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        String androidAppId = "com.lightplanx.xddk";
                        launch("https://play.google.com/store/apps/details?id=$androidAppId");
                      },
                      child: Text(
                        "Rate us on Google Play",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                context,
              ),
              Divider(thickness: 1),
              _buildItem(
                Icons.code_outlined,
                "Github Project",
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => launch("https://github.com/XDDK/LightPlan"),
                      child: Text(
                        "Click to view",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                context,
              ),
              Divider(thickness: 1),
              _buildItem(
                Icons.text_snippet_outlined,
                "Terms of Service",
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => launch("https://lightplanx.com/tos"),
                      child: Text(
                        "Click to view",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                context,
              ),
              Divider(thickness: 1),
              _buildItem(
                Icons.text_snippet_outlined,
                "Privacy Policy",
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => launch("https://lightplanx.com/privacy"),
                      child: Text(
                        "Click to view",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, Widget child, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500),
      child: MyContainer(
        padding: EdgeInsets.all(10),
        //padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
                  MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(icon, size: 35),
                SizedBox(width: 10),
                Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding:
                  MediaQuery.of(context).size.width < 600 ? EdgeInsets.only(left: 30, right: 30) : EdgeInsets.all(0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
