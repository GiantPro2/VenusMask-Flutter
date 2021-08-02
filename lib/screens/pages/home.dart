import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/custom.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:nb_utils/nb_utils.dart';

import 'engine.dart';

class Home extends StatefulWidget {
  final action;
  Home({this.action});
  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  @override
  initState() {
    super.initState();
    init();
  }

  checkHistory() {
    if (global_redHistory == null) {
      global_redHistory = '0';
    }
    if (global_blueHistory == null) {
      global_blueHistory = '0';
    }
    if (global_greenHistory == null) {
      global_greenHistory = '0';
    }
    if (global_yellowHistory == null) {
      global_yellowHistory = '0';
    }
    if (global_purpleHistory == null) {
      global_purpleHistory = '0';
    }
    if (global_whiteHistory == null) {
      global_whiteHistory = '0';
    }
    if (global_turquoiseHistory == null) {
      global_turquoiseHistory = '0';
    }
  }

  init() async {
    checkHistory();
  }

  List<Program> programList = [
    Program(
        title: 'Red Program',
        description:
            "Stimulates the production of the skin's ‘youthful' cells, Collagen and Elastin, so is perfect if you're looking to treat the signs of ageing. It can also help with signs of inflammation."),
    Program(
        title: 'Blue Program',
        description:
            "Ideal for treating acne-prone skin, Blue Light balances and clarifies the skin, killing the bacteria that causes acne."),
    Program(
        title: 'Green Program',
        description:
            "This calms the skin. It's perfect for dealing with pigmentation such as age spots and reducing the appearance of broken capillaries."),
    Program(
        title: 'Yellow Program',
        description:
            "This is the one for treating sensitive skin. It boosts circulation and lymphatic flow (drains toxins) as well as soothing and comforting the skin."),
    Program(
        title: 'Purple Program',
        description:
            "This treatment is a mix of red and blue light, it is a combination of two kinds of phototherapy, effective in the treatment of acne and repairs acne scars."),
    Program(
        title: 'Turquoise Program',
        description:
            "Penetrates the skin deeply, speeds up the living tissue metabolism and improves the appearance of fine lines and sagging skin."),
    Program(
        title: 'White Program',
        description:
            "This treatment penetrates the deeper layers of the skin to promote healing and skin repair."),
    Program(
        title: 'Custom Program',
        description:
            "Select 3 different colours and choose a time for each one (up to 10 mins)"),
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            height: size.height * 0.25,
          )
        ],
      ).paddingTop(20);
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
            MaterialButton(
              onPressed: () {
                global_currentProgram = index.toString();
                if (index == 8) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Custom(),
                    ),
                  );
                } else {
                  global_customProgramFlag = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Engine(),
                    ),
                  );
                }
              },
              height: 50,
              minWidth: 100,
              padding: const EdgeInsets.all(0.0),
              child: Text(
                'Go',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ).cornerRadiusWithClipRRect(25),
              textColor: white,
              color: t1_colorPrimary,
            ).paddingTop(20),
            Divider(
              color: redColor,
            ).paddingOnly(top: 20)
          ],
        ),
      ).paddingAll(20);
    }
  }
}

class Program {
  String title;
  String description;
  Program({this.title, this.description});
}
