import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:lighthouse_planner/ui/widgets/containers/my_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart'; 
// import 'package:provider/provider.dart';

// import '../../dao/task_dao_impl.dart';
// import '../../models/task.dart';
// import '../../tree_handler.dart';
// import '../widgets/bottom_bar.dart';
// import '../widgets/tree_preview.dart';
// import '../widgets/tree_timer.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildAbout(),
          Divider(thickness: 1),

          _buildSupportUs(),
          Divider(thickness: 1),

          _buildGithub(),
          Divider(thickness: 1),

          _buildTOS(),
          Divider(thickness: 1),

          _buildPrivacyPolicy(),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildGithub() {
    return GestureDetector(
      onTap: () { launch("https://github.com/XDDK"); },
      child: MyContainer(
        ripple: true,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //Settings UI: GITHUB Title
              Row(
                children: [
                  iconBuilder(Icons.code, 30),
                  textBuilder("Github Repository", 30, Colors.black, 1),
                ],
              ),

              //Empty container used for formatting
              SizedBox(height: 10),

              //Setting UI: GITHUB Description
              Row(
                children: [
                  SizedBox(width: 30),
                  iconBuilder(Icons.touch_app_outlined, 20),
                  textBuilder("Click to view", 20, Colors.black, 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return GestureDetector(
      onTap: () { print("TAP_PRIVACY_POLICY"); },
      child: MyContainer(
        ripple: true,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //Settings UI: PRIVACY_POLICY Title
              Row(
                children: [
                  iconBuilder(Icons.text_snippet_outlined, 30),
                  textBuilder("Privacy Policy", 30, Colors.black, 1),
                ],
              ),
      
              //Empty container used for formatting
              SizedBox(height: 10),

              //Settings UI: PRIVACY_POLICY Description
              Row(
                children: [
                  SizedBox(width: 30),
                  iconBuilder(Icons.touch_app_outlined, 20),
                  textBuilder("Click to view", 20, Colors.black, 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTOS() {
    return GestureDetector(
      onTap: () { print("TAP_TOS"); },
      child: MyContainer(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //Settings UI: TOS Title
              Row(
                children: [
                  iconBuilder(Icons.text_snippet_outlined, 30),
                  textBuilder("Terms of Service", 30, Colors.black, 1),
                ],
              ),

              //Empty container used for formatting
              SizedBox(height: 10),

              //Settings UI: TOS Description
              Row(
                children: [
                  SizedBox(width: 30),
                  iconBuilder(Icons.touch_app_outlined, 20),
                  textBuilder("Click to view", 20, Colors.black, 0),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportUs() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          //Settings UI: SUPPORT_US Title
          Row(
            children: [
              iconBuilder(Icons.favorite_border, 30),
              textBuilder("Support us", 30, Colors.black, 1),
            ],
          ),

          //Empty container used for formatting
          SizedBox(height: 10),

          //Settings UI: SUPPORT_US Description
          Row(
            children: [
              SizedBox(width: 30),
              iconBuilder(Icons.thumb_up_outlined, 20),
              SizedBox(width: 3),
              MyContainer(
                color: Colors.transparent,
                child: RichText(
                  text: TextSpan(
                    text: "Click to rate!",
                    style: customStyle(20, Colors.black, 0.0),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      if(kIsWeb) launch("https://play.google.com/store?hl=en&gl=US");
                      else LaunchReview.launch(androidAppId: "com.facebook.katana&hl=ko");
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbout() {
    String aboutDesc = 
      '''This is an open-source project created by two passionate students.
      Our aim is to provide people with a simple, free and open source planner for 
      any type of activity. Since it's open source, the project can be customized to
      everybodies liking. If you are interested, the full source code can be found ''';
    aboutDesc = aboutDesc.replaceAll("\n", " ");
    aboutDesc = aboutDesc.replaceAll("      ", "");

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          //Settings UI: ABOUT title
          Row(
            children: [
              iconBuilder(Icons.info_outline, 30),
              textBuilder("About", 30, Colors.black, 1),
            ],
          ),

          //Settings UI: ABOUT Description
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: aboutDesc,
                    style: customStyle(15, Colors.black, 0.0),
                  ),

                  TextSpan(
                    text: "here",
                    style: customStyle(15, Colors.blue, 0.0),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      launch("https://github.com/XDDK/LightPlan");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  MyContainer textBuilder(String text, double fontSize, Color color, double letterSpacing) {
    return MyContainer(
      color: Colors.transparent,
      child: Text(text, style: customStyle(fontSize, color, letterSpacing)),
    );
  }

  MyContainer iconBuilder(IconData icon, double size) {
    return MyContainer(
      child: Icon(icon, size: size),
      color: Colors.transparent
    );
  }

   TextStyle customStyle(double _fontSize, Color color, double letterSpacing) {
    return TextStyle(
      letterSpacing: letterSpacing,
      color: color,
      fontSize: _fontSize
    );
  }
}