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
import 'package:lightplan/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dao/preferences.dart';
import '../../theme_handler.dart';
import '../widgets/my_container.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
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
                  Icons.nightlight_round,
                  AppLocalizations.of(context).translate('currentThemeTitle'),
                  DropdownButton(
                    value: themeHandler.currentThemeIndex,
                    onChanged: (int newSelection) async {
                      await Preferences.getFutureInstance();
                      setState(() => themeHandler.changeTheme(Preferences.getInstance(), newSelection));
                    },
                    items: <int>[0, 1, 2, 3].map((currentSelection) {
                      return DropdownMenuItem<int>(
                        value: currentSelection,
                        child: _buildDropdownWidget(currentSelection),
                      );
                    }).toList(),
                  ),
                  context),
              Divider(thickness: 1),
              _buildItem(
                Icons.info_outline,
                AppLocalizations.of(context).translate('aboutTitle'),
                RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context).translate('aboutLine1'),
                    style: themeHandler.currentTheme.textTheme.headline4,
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context).translate('aboutLink-Github'),
                        style: themeHandler.currentTheme.textTheme.headline4.copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () => launch("https://github.com/XDDK/LightPlan"),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context).translate('aboutLine2'),
                        style: themeHandler.currentTheme.textTheme.headline4,
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context).translate('aboutLink-Web'),
                        style: themeHandler.currentTheme.textTheme.headline4.copyWith(color: Colors.blue),
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
                AppLocalizations.of(context).translate('supportUsTitle'),
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
                        AppLocalizations.of(context).translate('supportUsClick'),
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
                AppLocalizations.of(context).translate('githubTitle'),
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => launch("https://github.com/XDDK/LightPlan"),
                      child: Text(
                        AppLocalizations.of(context).translate('clickToView'),
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
                AppLocalizations.of(context).translate('tosTitle'),
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => launch("https://lightplanx.com/tos"),
                      child: Text(
                        AppLocalizations.of(context).translate('clickToView'),
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
                AppLocalizations.of(context).translate('privacyTitle'),
                Row(
                  mainAxisAlignment:
                      MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => launch("https://lightplanx.com/privacy"),
                      child: Text(
                        AppLocalizations.of(context).translate('clickToView'),
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

  Widget _buildDropdownWidget(int value) {
    IconData iconData;
    String text;

    switch (value) {
      case 1:
        iconData = Icons.wb_sunny_outlined; text = AppLocalizations.of(context).translate('themeLight');
        break;
      case 2:
        iconData = Icons.nights_stay_outlined; text = AppLocalizations.of(context).translate('themeDark');
        break;
      case 3:
        iconData = Icons.blur_on; text = AppLocalizations.of(context).translate('themeBlack');
        break;
      default:
        iconData = Icons.phone_android_outlined; text = AppLocalizations.of(context).translate('themeSystem');
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(iconData),
        Text("$text"),
      ],
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
