import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/bottomnavigation.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/walkThrough/IntroScreen.dart';

import 'Walkthrough.dart';

class T1WalkThrough extends StatelessWidget {
  static var tag = "/T1WalkThrough";

  final List<Walkthrough> list = [
    Walkthrough(
        title: "Turn on your Bluetooth",
        content: "Please turn on Bluetooth on your device",
        imageIcon: t1_walk1),
    Walkthrough(
        title: "Plug in your Venus Mask",
        content: "Ensure your Venus mask is plugged in.",
        imageIcon: t1_walk2),
    Walkthrough(
        title: "Connect to your Venus Mask",
        content: "Press skip to search for your Venus Mask and tap to connect",
        imageIcon: t1_walk3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IntroScreen(
          list,
          MaterialPageRoute(builder: (context) => T2BottomNavigation()),
        ),
      ),
    );
  }
}
