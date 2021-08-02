import 'dart:async';
import 'dart:convert';

// import 'package:audio_service/audio_service.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/circular_countdown_timer.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/progress_dialog.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:intl/intl.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:wakelock/wakelock.dart';

import '../../main.dart';
import '../../utils/global.dart';
import '../../utils/global.dart';
import '../../utils/global.dart';
import 'custom.dart';
// import 'package:background_process/utils/global.dart';

// void _backgroundTaskEntrypoint() async {
//   AudioServiceBackground.run(() => AudioPlayerTask());
// }

class Engine extends StatefulWidget {
  @override
  _Engine createState() => new _Engine();
}

class _Engine extends State<Engine>  with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

///////////////////////////////////////////////////////////////////
  SharedPreferences prefs;
  var count = [];
  var _secs = 0;
  bool _onBackground = false;
  int _status = 0;
//////////////////////////////////////////////////////////////////

  ProgressDialog pgLogin;
  CountDownController _controller = CountDownController();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    initPlatformState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    var prefs = await SharedPreferences.getInstance();
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        if(_onBackground){
          setState(() {
            _onBackground = false;
          });
        }
        prefs.setBool('_onBackground', false);
        BackgroundFetch.stop();
        await FlutterBackground.disableBackgroundExecution();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        // BackgroundFetch.start();
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        prefs.setBool('_onBackground', true);
        Timer(Duration(milliseconds: 10), () => prefs.setString('_time', _controller.getSec()));
        print(_controller.getTime());
        BackgroundFetch.start();
        await FlutterBackground.enableBackgroundExecution();
        // BackgroundFetch.start().then((value) => _backgroundFetch);
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  bool _isPause = false;
  Color programColor;
  String programName;

  init() async {
    if (global_duration == null) {
      global_duration = '10';
    }
    getProgram(global_currentProgram);
    if (global_customProgramFlag != true) {
      global_duration = '10';
    }
    if (global_customProgramFlag == true && global_customProgramIndex != 0) {
      await sendRequest(global_currentProgram, true);
    } else {
      _isPause = true;
      Timer(Duration(milliseconds: 10), () => _controller.pause());
    }
    // setState(() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('_status', 0);
    prefs.setBool('completed', false);
    prefs.setBool('_onBackground', false);
    await FlutterBackground.initialize(
        androidConfig: FlutterBackgroundAndroidConfig(
        notificationTitle: "Venus Mask",
        notificationText: "",
        notificationImportance: AndroidNotificationImportance.Default,
        notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'),)
    );
    // await FlutterBackground.enableBackgroundExecution();
    // });
  }

  getProgram(String index) {
    if (global_customProgramFlag == true) {
      index = global_customProgram[global_customProgramIndex]['program'];
      global_duration = global_customProgram[global_customProgramIndex]['duration'];
    }

    if (index == '1') {
      programName = 'Red Program';
      programColor = Color(0xffea4335);
    } else if (index == '2') {
      programName = 'Blue Program';
      programColor = Color(0xff4285f4);
    } else if (index == '3') {
      programName = 'Green Program';
      programColor = greenColor;
    } else if (index == '4') {
      programName = 'Yellow Program';
      programColor = Color(0xfff08717);
    } else if (index == '5') {
      programName = 'Purple Program';
      programColor = purple;
    } else if (index == '6') {
      programName = 'Turquoise Program';
      programColor = Color(0xff3bcabb);
    } else if (index == '7') {
      programName = 'White Program';
      programColor = grey;
    } else {
      programName = 'Custome Program';
      programColor = redColor;
    }
  }

  void sendText(String str) async {
    print("!!!!!!!!!!!!!!!!!!!!!!");
    print(str);
    try {
      global_connection.output.add(utf8.encode(str + "\r\n"));
      await global_connection.output.allSent;
      toast("successfully sent");
    } catch (e) {
      // Ignore error, but notify state
      toast(e.toString());
      setState(() {});
    }
  }

  sendRequest(String index, bool onOFF) async {
    try {
      if (onOFF) {
        if (index == '1') {
          await sendText('1');
        } else if (index == '2') {
          await sendText('2');
        } else if (index == '3') {
          await sendText('3');
        } else if (index == '4') {
          await sendText('4');
        } else if (index == '5') {
          await sendText('5');
        } else if (index == '6') {
          await sendText('6');
        } else if (index == '7') {
          await sendText('7');
        } else {
          await sendText(global_customProgram[0]['program']);
          print('err');
        }
      } else {
        await sendText('0');
      }
    } catch (e) {
      print(e);
    }
  }

  updateHistory() async {
    final prefs = await SharedPreferences.getInstance();
    global_redHistory = prefs.getString('global_redHistory') ?? '0';
    global_blueHistory = prefs.getString('global_blueHistory') ?? '0';
    global_greenHistory = prefs.getString('global_greenHistory') ?? '0';
    global_yellowHistory = prefs.getString('global_yellowHistory') ?? '0';
    global_purpleHistory = prefs.getString('global_purpleHistory') ?? '0';
    global_turquoiseHistory = prefs.getString('global_turquoiseHistory') ?? '0';
    global_whiteHistory = prefs.getString('global_whiteHistory') ?? '0';

    if (global_currentProgram == '1') {
      global_redHistory =
          (int.parse(global_redHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_redHistory', global_redHistory);
    } else if (global_currentProgram == '2') {
      global_blueHistory =
          (int.parse(global_blueHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_blueHistory', global_blueHistory);
    } else if (global_currentProgram == '3') {
      global_greenHistory =
          (int.parse(global_greenHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_greenHistory', global_greenHistory);
    } else if (global_currentProgram == '4') {
      global_yellowHistory =
          (int.parse(global_yellowHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_yellowHistory', global_yellowHistory);
    } else if (global_currentProgram == '5') {
      global_purpleHistory =
          (int.parse(global_purpleHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_purpleHistory', global_purpleHistory);
    } else if (global_currentProgram == '6') {
      global_turquoiseHistory =
          (int.parse(global_turquoiseHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_turquoiseHistory', global_turquoiseHistory);
    } else if (global_currentProgram == '7') {
      global_whiteHistory =
          (int.parse(global_whiteHistory) + int.parse(global_duration))
              .toString();
      prefs.setString('global_whiteHistory', global_whiteHistory);
    }
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,  // <-- minutes
        stopOnTerminate: false,
        startOnBoot: true,
    ), _backgroundFetch, (String taskId) async {
      print("before timer-=-=-=-=-=-=-${DateTime.now()}");
      Timer.periodic(Duration(seconds: int.parse(prefs.getString('_time')) - 60), (Timer t){

      });
      Timer(Duration(milliseconds: int.parse(prefs.getString('_time')) - 60),(){

      });
      BackgroundFetch.finish(taskId);
    });
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pgLogin = new ProgressDialog(context);
    return new Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                programName,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              Text('Put your mask on and press play to start').paddingOnly(top: 20, bottom: 30),

              CircularCountDownTimer(
                duration: int.parse(global_duration) * 60,
                controller: _controller,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                color: Colors.white,
                fillColor: programColor,
                backgroundColor: null,
                strokeWidth: 10.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                    fontSize: 50.0,
                    color: programColor,
                    fontWeight: FontWeight.bold),
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                onComplete: () async {
                    setState(() {
                      _isPause = true;
                    });
                    print(prefs.getBool('_onBackground'));
                    print(prefs.getBool('completed'));
                    if(prefs.getBool('_onBackground') == false && prefs.getBool('completed') == false){
                      await sendRequest(global_currentProgram, false);
                      if (global_customProgramFlag == true) {
                        updateHistory();
                        global_customProgramIndex = global_customProgramIndex + 1;
                        global_currentProgram = global_customProgram[global_customProgramIndex]['program'];
                        if (global_customProgramIndex == global_customProgram.length) {
                          global_customProgramFlag = false;
                          setState(() {
                            Wakelock.disable();
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pop(context);
                          });
                          return;
                        } else {
                          pgLogin.show();
                          Future.delayed(const Duration(seconds: 3), () {
                            pgLogin.hide();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Engine(),
                              ),
                            );
                          });
                        }
                      } else {
                        updateHistory();
                        setState(() {
                          Wakelock.disable();
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Engine(),
                          ),
                        );
                      }
                    }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: t1_colorPrimary,
          onPressed: () async {
            // var prefs = await SharedPreferences.getInstance();
            prefs.setBool('_onBackground', false);
            if (_isPause) {
              prefs.setInt('_status', 1);
              // start();
              setState(() {
                // count.add(DateTime.now());
                _status = 1;
                _isPause = false;
                Wakelock.enable();
              });
              _controller.resume();
              await sendRequest(global_currentProgram, true);
            } else {
              prefs.setInt('_status', 0);
              setState(() {
                _status = 0;
                _isPause = true;
                Wakelock.disable();
              });
              _controller.pause();
              BackgroundFetch.stop();
              await sendRequest(global_currentProgram, false);
            }
            print(_status);
          },
          icon: Icon(_isPause ? Icons.play_arrow : Icons.pause),
          label: Text(_isPause ? "Start" : "Pause")),
      // label: Text("Check Status")),
    );
  }

  _backgroundFetch(String taskId) async{
    // prefs.setString('taskId', taskId);
    if(prefs.getInt('_status') == 1 ){
      Timer(Duration(seconds: int.parse(prefs.getString('_time'))), () async {
        print("(_controller.getSec()=-=-=--=-- ${_controller.getSec()}");
        print("called time ${DateTime.now()}");
        setState(() {
          // count.add(DateTime.now());
          _onBackground = true;
          _isPause = true;
          // programColor = Colors.purple;
          _status = 0;
        });
        prefs.setBool('_onBackground', true);
        prefs.setInt('_status', 0);
        await sendRequest(global_currentProgram, false);
        if (global_customProgramFlag == true) {
          updateHistory();
          global_customProgramIndex = global_customProgramIndex + 1;
          global_currentProgram = global_customProgram[global_customProgramIndex]['program'];
          if (global_customProgramIndex == global_customProgram.length) {
            global_customProgramFlag = false;
            prefs.setBool('completed', true);
            Future.delayed(const Duration(milliseconds: 100), () {
              print('caled=-=--=');
              Navigator.pop(context);
            });
            return;
          } else {
            pgLogin.show();
            Future.delayed(const Duration(seconds: 3), () {
              pgLogin.hide();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Engine(),
                ),
              );
            });
          }
        } else {
          prefs.setBool('completed', true);
          updateHistory();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Engine(),
            ),
          );
        }
        BackgroundFetch.finish(taskId);
      });
    } else {
      prefs.setInt('_status', 0);
      BackgroundFetch.finish(taskId);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    // BackgroundFetch.finish(prefs.getString('taskId'));
    super.dispose();
  }
}