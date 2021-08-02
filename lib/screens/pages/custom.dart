import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/engine.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

import 'bluetooth/custom_engine.dart';

class Custom extends StatefulWidget {
  @override
  _Custom createState() => new _Custom();
}

class _Custom extends State<Custom> {
  double progressValue1 = 0.0;
  double progressValue2 = 0.0;
  double progressValue3 = 0.0;

  List<bool> buttonGroup1 = [true, false, false, false, false, false, false];
  List<bool> buttonGroup2 = [true, false, false, false, false, false, false];
  List<bool> buttonGroup3 = [true, false, false, false, false, false, false];

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}
  checkButtonBorder1(int index) {
    for (int i = 0; i <= 6; i++) {
      setState(() {
        if (index - 1 == i) {
          buttonGroup1[i] = true;
        } else {
          buttonGroup1[i] = false;
        }
      });
    }
  }

  checkButtonBorder2(int index) {
    for (int i = 0; i <= 6; i++) {
      setState(() {
        if (index - 1 == i) {
          buttonGroup2[i] = true;
        } else {
          buttonGroup2[i] = false;
        }
      });
    }
  }

  checkButtonBorder3(int index) {
    for (int i = 0; i <= 6; i++) {
      setState(() {
        if (index - 1 == i) {
          buttonGroup3[i] = true;
        } else {
          buttonGroup3[i] = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: size.height * 0.25,
              )
            ],
          ).paddingTop(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundButton(Color(0xffea4335), Color(0xffea4335), buttonGroup1[0],
                  () {
                checkButtonBorder1(1);
              }),
              RoundButton(Color(0xff4285f4), Color(0xff4285f4), buttonGroup1[1],
                  () {
                checkButtonBorder1(2);
              }),
              RoundButton(greenColor, greenColor, buttonGroup1[2], () {
                checkButtonBorder1(3);
              }),
              RoundButton(Color(0xfff08717), Color(0xfff08717), buttonGroup1[3],
                  () {
                checkButtonBorder1(4);
              }),
              RoundButton(purple, purple, buttonGroup1[4], () {
                checkButtonBorder1(5);
              }),
              RoundButton(Color(0xff3bcabb), Color(0xff3bcabb), buttonGroup1[5],
                  () {
                checkButtonBorder1(6);
              }),
              RoundButton(white, grey, buttonGroup1[6], () {
                checkButtonBorder1(7);
              }),
            ],
          ),
          Card(
              color: white,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              elevation: 2.0,
              shadowColor: Colors.black,
              child: ListTile(
                  title: CupertinoSlider(
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    value: progressValue1,
                    activeColor: t1_colorPrimary,
                    onChanged: (val) {
                      progressValue1 = val;
                      setState(() {});
                    },
                  ),
                  trailing: Text(
                    "Duration =  ${progressValue1.toInt()}",
                    style: primaryTextStyle(),
                  ))).paddingBottom(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundButton(Color(0xffea4335), Color(0xffea4335), buttonGroup2[0],
                  () {
                checkButtonBorder2(1);
              }),
              RoundButton(Color(0xff4285f4), Color(0xff4285f4), buttonGroup2[1],
                  () {
                checkButtonBorder2(2);
              }),
              RoundButton(greenColor, greenColor, buttonGroup2[2], () {
                checkButtonBorder2(3);
              }),
              RoundButton(Color(0xfff08717), Color(0xfff08717), buttonGroup2[3],
                  () {
                checkButtonBorder2(4);
              }),
              RoundButton(purple, purple, buttonGroup2[4], () {
                checkButtonBorder2(5);
              }),
              RoundButton(Color(0xff3bcabb), Color(0xff3bcabb), buttonGroup2[5],
                  () {
                checkButtonBorder2(6);
              }),
              RoundButton(white, grey, buttonGroup2[6], () {
                checkButtonBorder2(7);
              }),
            ],
          ),
          Card(
              color: white,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              elevation: 2.0,
              shadowColor: Colors.black,
              child: ListTile(
                  title: CupertinoSlider(
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    value: progressValue2,
                    activeColor: t1_colorPrimary,
                    onChanged: (val) {
                      progressValue2 = val;
                      setState(() {});
                    },
                  ),
                  trailing: Text(
                    "Duration =  ${progressValue2.toInt()}",
                    style: primaryTextStyle(),
                  ))).paddingBottom(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundButton(Color(0xffea4335), Color(0xffea4335), buttonGroup3[0],
                  () {
                checkButtonBorder3(1);
              }),
              RoundButton(Color(0xff4285f4), Color(0xff4285f4), buttonGroup3[1],
                  () {
                checkButtonBorder3(2);
              }),
              RoundButton(greenColor, greenColor, buttonGroup3[2], () {
                checkButtonBorder3(3);
              }),
              RoundButton(Color(0xfff08717), Color(0xfff08717), buttonGroup3[3],
                  () {
                checkButtonBorder3(4);
              }),
              RoundButton(purple, purple, buttonGroup3[4], () {
                checkButtonBorder3(5);
              }),
              RoundButton(Color(0xff3bcabb), Color(0xff3bcabb), buttonGroup3[5],
                  () {
                checkButtonBorder3(6);
              }),
              RoundButton(white, grey, buttonGroup3[6], () {
                checkButtonBorder3(7);
              }),
            ],
          ),
          Card(
              color: white,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              elevation: 2.0,
              shadowColor: Colors.black,
              child: ListTile(
                  title: CupertinoSlider(
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    value: progressValue3,
                    activeColor: t1_colorPrimary,
                    onChanged: (val) {
                      progressValue3 = val;
                      setState(() {});
                    },
                  ),
                  trailing: Text(
                    "Duration =  ${progressValue3.toInt()}",
                    style: primaryTextStyle(),
                  ))).paddingBottom(15),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Save Changes and Go',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ).paddingBottom(10),
                MaterialButton(
                  onPressed: () {
                    if (progressValue1.toInt() +
                            progressValue2.toInt() +
                            progressValue3.toInt() ==
                        0) {
                      toast("Choose at least one program");
                    } else {
                      print('progressValue1');
                      print(progressValue1.toInt().toString());
                      print('progressValue2');
                      print(progressValue2.toInt().toString());
                      print('progressValue3');
                      print(progressValue3.toInt().toString());
                      print('buttonGroup1');
                      print(buttonGroup1.indexOf(true) + 1);
                      print('buttonGroup2');
                      print(buttonGroup2.indexOf(true) + 1);
                      print('buttonGroup3');
                      print(buttonGroup3.indexOf(true) + 1);
                      global_customProgram = [];
                      if (progressValue1.toInt() != 0) {
                        global_customProgram.add({
                          'program':
                              (buttonGroup1.indexOf(true) + 1).toString(),
                          'duration': progressValue1.toInt().toString()
                        });
                      }
                      if (progressValue2.toInt() != 0) {
                        global_customProgram.add({
                          'program':
                              (buttonGroup2.indexOf(true) + 1).toString(),
                          'duration': progressValue2.toInt().toString()
                        });
                      }
                      if (progressValue3.toInt() != 0) {
                        global_customProgram.add({
                          'program':
                              (buttonGroup3.indexOf(true) + 1).toString(),
                          'duration': progressValue3.toInt().toString()
                        });
                      }
                      print('global_customProgram');
                      print(global_customProgram.toString());
                      global_customProgramFlag = true;
                      global_customProgramIndex = 0;
                      // Navigator.push(
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => Engine(),
                          builder: (context) => (global_customProgram.length > 1) ? CustomEngine() : Engine(),
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
                ).paddingTop(20)
              ],
            ),
          ).paddingAll(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon.png',
                height: size.height * 0.15,
              )
            ],
          ).paddingAll(20),
        ],
      ),
    ));
  }
}
