import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/home.dart';
import 'package:nb_utils/nb_utils.dart';

class Setup extends StatefulWidget {
  @override
  _Setup createState() => new _Setup();
}

class _Setup extends State<Setup> {
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}
  List<Program> programList = [
    Program(
        title: 'Step 1',
        description: "Ensure Bluetooth is enabled on your device"),
    Program(
        title: 'Step 2',
        description:
            "Open the Venus Mask app and search for Bluetooth devices"),
    Program(title: 'Step 3', description: 'Tap to connect to your Venus Mask'),
    Program(
        title: 'Step 4',
        description:
            'Choose a program or design your own in the custom program mode'),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child:
            // Text('123')

            ListView.builder(
          itemCount: programList.length + 2,
          itemBuilder: (context, i) {
            return _listViewItemBuilder(context, i);
          },
        ),
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    return oneItem(context, index);
  }

  Widget oneItem(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;

    if (index == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset(
          //       'assets/logo.png',
          //       height: size.height * 0.25,
          //     )
          //   ],
          // ).paddingTop(20),
          Text(
            'Setup',
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.w800, color: grey),
          ),
          Text(
            'Follow the below steps to connect to your Venus Mask',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ).paddingOnly(top: 40, left: 20, right: 20);
    } else if (index == programList.length + 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon.png',
            height: size.height * 0.15,
          )
        ],
      ).paddingAll(20);
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              this.programList[index - 1].title,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ).paddingBottom(10),
            Text(
              this.programList[index - 1].description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ).paddingOnly(left: 20, right: 20, top: 20);
    }
  }
}
