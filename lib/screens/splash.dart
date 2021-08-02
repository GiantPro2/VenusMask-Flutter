import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/walkThrough/T1WalkThrough.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnavigation.dart';

class Splash extends StatefulWidget {
  static String tag = '/SDSplashScreen';

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    init();
    startTime();
  }

  init() {}

  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // builder: (context) => T2BottomNavigation(),T1WalkThrough
        builder: (context) => T1WalkThrough(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              height: size.height * 0.2,
            ).paddingOnly(top: size.height * 0.2)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: size.height * 0.25,
            ).paddingOnly(top: size.height * 0.4)
          ],
        ),
      ],
    ));
  }
}
