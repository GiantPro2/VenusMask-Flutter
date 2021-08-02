import 'dart:async';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/circular_countdown_timer.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/progress_dialog.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:move_to_background/move_to_background.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:wakelock/wakelock.dart';

var _time = 0;

class CustomEngine extends StatefulWidget {
  @override
  _CustomEngine createState() => new _CustomEngine();
}

class _CustomEngine extends State<CustomEngine>  with WidgetsBindingObserver, TickerProviderStateMixin {
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  Future singleNotification(String message, String subtext, int hashcode, {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.max,
      priority: Priority.max,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
    localNotificationsPlugin.show(
        hashcode, message, subtext, platformChannel,
        payload: hashcode.toString());
  }

  Future progressNotification(String message, String subtext, int hashcode, bool ongoing, {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: ongoing,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
    localNotificationsPlugin.show(
        hashcode, message, subtext, platformChannel,
        payload: hashcode.toString());
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

//////////////////////////////////////////////////////////////////
  SharedPreferences prefs;
  var count = [];
  var _firstDuration = 0;
  List <String> _duration = [];
  Timer _secondTimer, _thirdTimer;
//////////////////////////////////////////////////////////////////

  ProgressDialog pgLogin;
  List<CountDownController> _controller = List.generate(3, (index) => CountDownController());
  @override
  initState() {
    super.initState();
    initializeNotifications();
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
        prefs.setBool('_onBackground', false);
        // Timer(Duration(milliseconds: 10), () => prefs.setInt('_time', int.parse(_controller[1].getSec())));
        // _secondTimer.cancel();
        print("duration=-=-=- $_time");
        // print("duration=-=-=- ${prefs.getInt('_time')}");
        if(global_customProgramIndex == 1 || prefs.getInt('_controller') == 1){
          _controller[1].forward(duration: _time);
        } else if(global_customProgramIndex == 2 || prefs.getInt('_controller') == 2){
          _controller[1].restart(duration: 0);
          _controller[2].forward(duration: _time);
        }
        await FlutterBackground.disableBackgroundExecution();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        // BackgroundFetch.start();
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        prefs.setBool('_onBackground', true);
        MoveToBackground.moveTaskToBack();
        await FlutterBackground.enableBackgroundExecution();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  bool _isPause = false;
  List <Color> programColor = [];
  List <String> programName = [];

  init() async {
    if (global_duration == null) {
      global_duration = '10';
    }
    for(var i = 0; i < global_customProgram.length; i++){
      getProgram((i+1).toString(), i);
    }

    if (global_customProgramFlag != true) {
      global_duration = '10';
    }
    if (global_customProgramFlag == true && global_customProgramIndex != 0) {
      // print('0-=-=--');
      await sendRequest(global_currentProgram, true);
    } else {
      // print('1-=-=--');
      _isPause = true;
      Timer(Duration(milliseconds: 10), () => _controller[0].pause());
      Timer(Duration(milliseconds: 10), () => _controller[1].pause());
      if(global_customProgram.length > 2)
      Timer(Duration(milliseconds: 10), () => _controller[2].pause());
    }
    // setState(() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('_customStatus', 0);
    prefs.setInt('_controller', 0);
    prefs.setInt('_time', 0);
    prefs.setString('_firstDuration', '0');
    prefs.setBool('_onBackground', false);
    prefs.setBool('_isPause', false);
    await FlutterBackground.initialize(
        androidConfig: FlutterBackgroundAndroidConfig(
          notificationTitle: "Venus Mask",
          notificationText: "",
          notificationImportance: AndroidNotificationImportance.High,
          notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'),)
    );
  }

  getProgram(String programIndex, index) {
    if (global_customProgramFlag == true) {
      programIndex = global_customProgram[index]['program'];
      // global_duration = global_customProgram[index]['duration'];
      setState(() {
        _duration.insert(index, global_customProgram[index]['duration']);
      });
    }

    if (programIndex == '1') {
      programName.insert(index, 'Red Program');
      programColor.insert(index, Color(0xffea4335));
    } else if (programIndex == '2') {
      programName.insert(index, 'Blue Program');
      programColor.insert(index, Color(0xff4285f4));
    } else if (programIndex == '3') {
      programName.insert(index, 'Green Program');
      programColor.insert(index, greenColor);
    } else if (programIndex == '4') {
      programName.insert(index, 'Yellow Program');
      programColor.insert(index, Color(0xfff08717));
    } else if (programIndex == '5') {
      programName.insert(index, 'Purple Program');
      programColor.insert(index, purple);
    } else if (programIndex == '6') {
      programName.insert(index, 'Turquoise Program');
      programColor.insert(index, Color(0xff3bcabb));
    } else if (programIndex == '7') {
      programName.insert(index, 'White Program');
      programColor.insert(index, grey);
    } else {
      programName.insert(index, 'Custom Program');
      programColor.insert(index, redColor);
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

  updateHistory(duration, currentProgram) async {
    // print('update History======== $duration');
    // final prefs = await SharedPreferences.getInstance();
    global_redHistory = prefs.getString('global_redHistory') ?? '0';
    global_blueHistory = prefs.getString('global_blueHistory') ?? '0';
    global_greenHistory = prefs.getString('global_greenHistory') ?? '0';
    global_yellowHistory = prefs.getString('global_yellowHistory') ?? '0';
    global_purpleHistory = prefs.getString('global_purpleHistory') ?? '0';
    global_turquoiseHistory = prefs.getString('global_turquoiseHistory') ?? '0';
    global_whiteHistory = prefs.getString('global_whiteHistory') ?? '0';

    if (currentProgram == '1') {
      global_redHistory = (int.parse(global_redHistory) + duration).toString();
      prefs.setString('global_redHistory', global_redHistory);
    } else if (currentProgram == '2') {
      // print('currentProgram======== $currentProgram');
      global_blueHistory = (int.parse(global_blueHistory) + duration).toString();
      prefs.setString('global_blueHistory', global_blueHistory);
    } else if (currentProgram == '3') {
      // print('currentProgram======== $currentProgram');
      global_greenHistory = (int.parse(global_greenHistory) + duration).toString();
      prefs.setString('global_greenHistory', global_greenHistory);
    } else if (currentProgram == '4') {
      // print('currentProgram======== $currentProgram');
      global_yellowHistory = (int.parse(global_yellowHistory) + duration).toString();
      prefs.setString('global_yellowHistory', global_yellowHistory);
    } else if (currentProgram == '5') {
      // print('currentProgram======== $currentProgram');
      global_purpleHistory = (int.parse(global_purpleHistory) + duration).toString();
      prefs.setString('global_purpleHistory', global_purpleHistory);
    } else if (currentProgram == '6') {
      // print('currentProgram======== $currentProgram');
      global_turquoiseHistory = (int.parse(global_turquoiseHistory) + duration).toString();
      prefs.setString('global_turquoiseHistory', global_turquoiseHistory);
    } else if (currentProgram == '7') {
      // print('currentProgram======== $currentProgram');
      global_whiteHistory = (int.parse(global_whiteHistory) + duration).toString();
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
        child: Column(
          children: [
            Text('Put your mask on and press play to start').paddingOnly(top: 70, bottom: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      programName[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                    ),

                    CircularCountDownTimer(
                      duration: int.parse(_duration[0]) * 60,
                      controller: _controller[0],
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                      color: Colors.white,
                      fillColor: programColor[0],
                      backgroundColor: null,
                      strokeWidth: 10.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: 50.0,
                          color: programColor[0],
                          fontWeight: FontWeight.bold),
                      isReverse: true,
                      isReverseAnimation: true,
                      isTimerTextShown: true,
                      onComplete: () async {
                        // if(global_customProgram.length > 1 && !prefs.getBool('_onBackground') && !prefs.getBool('completed1')){
                        //   updateHistory();
                        //   await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
                        //   global_customProgramIndex = global_customProgramIndex + 1;
                        //   prefs.setInt('_controller', global_customProgramIndex);
                        //   Future.delayed(const Duration(seconds: 3), () async {
                        //     await sendRequest(global_customProgram[global_customProgramIndex]['program'], true);
                        //     _controller[1].resume();
                        //   });
                        // }
                        if (prefs.getBool('_onBackground') == false) {
                          Future.delayed(Duration(seconds: 3), () => _controller[1].resume());
                        }
                      },
                    ),

                    if(global_customProgram.length > 1)...[
                      Text(
                        programName[1],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                      ),

                      CircularCountDownTimer(
                        duration: int.parse(_duration[1]) * 60,
                        controller: _controller[1],
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        color: Colors.white,
                        fillColor: programColor[1],
                        backgroundColor: null,
                        strokeWidth: 10.0,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                            fontSize: 50.0,
                            color: programColor[1],
                            fontWeight: FontWeight.bold),
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        onComplete: () async {
                          // if(!prefs.getBool('_onBackground') && !prefs.getBool('completed2')){
                          //   if(global_customProgram.length > 2){
                          //     updateHistory();
                          //     await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
                          //     global_customProgramIndex = global_customProgramIndex + 1;
                          //     prefs.setInt('_controller', global_customProgramIndex);
                          //     Future.delayed(const Duration(seconds: 3), () async {
                          //       await sendRequest(global_customProgram[global_customProgramIndex]['program'], true);
                          //       _controller[2].resume();
                          //     });
                          //   }
                          //   else {
                          if(global_customProgram.length == 2){
                            setState(() {
                              _isPause = true;
                            });
                            if(prefs.getBool('_onBackground') == false){
                              Navigator.pop(context);
                            }
                          } else if(prefs.getBool('_onBackground') == false){
                            _controller[2].resume();
                          }
                          // }
                        },
                      ),
                    ],

                    if(global_customProgram.length > 2)...[
                      Text(
                        programName[2],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                      ),

                      CircularCountDownTimer(
                        duration: int.parse(_duration[2]) * 60,
                        controller: _controller[2],
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        color: Colors.white,
                        fillColor: programColor[2],
                        backgroundColor: null,
                        strokeWidth: 10.0,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                            fontSize: 50.0,
                            color: programColor[2],
                            fontWeight: FontWeight.bold),
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        onComplete: () async {
                          // if(!prefs.getBool('_onBackground') && !prefs.getBool('completed3')){
                          //   updateHistory();
                          //   prefs.setInt('_controller', 0);
                          //   await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
                            setState(() {
                              _isPause = true;
                            });
                            if(prefs.getInt('_controller') == 0){
                              Navigator.pop(context);
                            }
                          // }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: t1_colorPrimary,
          onPressed: () async {
            localNotificationsPlugin.cancelAll();
            var _ti = 0;
            print(global_customProgram);
            if (_isPause) {
              prefs.setInt('_customStatus', 1);
              setState(() {
                _isPause = false;
                prefs.setBool('_isPause', false);
                Timer(Duration(milliseconds: 10), () => prefs.setString('_firstDuration', _controller[0].getSec()));
                Wakelock.enable();
              });
              _controller[global_customProgramIndex].resume();
              BackgroundFetch.start();
              await sendRequest(global_customProgram[global_customProgramIndex]['program'], true);
            } else {
              prefs.setInt('_customStatus', 0);
              setState(() {
                _isPause = true;
                prefs.setBool('_isPause', true);
                Timer(Duration(milliseconds: 10), () => prefs.setString('_firstDuration', _controller[0].getSec()));
                Wakelock.disable();
              });
              _controller[global_customProgramIndex].pause();
              BackgroundFetch.stop();
              await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
            }
          },
          icon: Icon(_isPause ? Icons.play_arrow : Icons.pause),
          label: Text(_isPause ? "Start" : "Pause")),
      // label: Text("Check Status")),
    );
  }

  _backgroundFetch(String taskId) async {
    prefs.setString('taskId', taskId);
    var t = DateTime.now();
    // Timer(Duration(milliseconds: 10), () => prefs.setString('_firstTime', _controller[prefs.getInt('_controller')].getSec()));
    if(prefs.getInt('_customStatus') == 1 ){
      var duration2 = (global_customProgram.length > 1) ? int.parse(global_customProgram[1]['duration']) * 60 : 0;
      var duration3 = (global_customProgram.length > 2) ? int.parse(global_customProgram[2]['duration']) * 60 : 0;
      print('Start Time::${DateFormat('hh:mm:ss').format(t)}');
      // await singleNotification("Start Time", DateFormat('hh:mm:ss').format(t).toString(), 0011);
      prefs.setInt('_customStatus', 0);
      Timer.periodic(Duration(seconds: 1), (sec) async {
        if(sec.tick >= int.parse(prefs.getString('_firstDuration'))){
          if(int.parse(prefs.getString('_firstDuration')) > 0){
            sec.cancel();
            t = DateTime.now();
            print('FIRST COMMAND:::::::::::::${DateFormat('hh:mm:ss').format(t)}::::::::::');
            // await singleNotification("First Command", DateFormat('hh:mm:ss').format(t).toString(), 001,);
            updateHistory(int.parse(_duration[0]), global_customProgram[0]['program']);
            await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
            global_customProgramIndex = global_customProgramIndex + 1;
            // prefs.setInt('_controller', global_customProgramIndex);
            prefs.setInt('_controller', 1);
          }
          Future.delayed(const Duration(seconds: 3), () async {
            // if(global_customProgramIndex == 1){
            if(prefs.getInt('_controller') == 1){
              await sendRequest(global_customProgram[global_customProgramIndex]['program'], true);
              prefs.setInt('_time', 0);
              // if (prefs.getBool('_onBackground') == false) {
              //   _controller[1].resume();
              // }
            }
            secondTimer(taskId , duration2, duration3);
          });
        } else if(prefs.getBool('_isPause') == true) {
          sec.cancel();
        } else {
          print("timer1=== ${sec.tick}");
          // await progressNotification("First Timer $_time", DateFormat('hh:mm:ss').format(t).toString(), 010, true);
        }
      });
    } else {
      prefs.setInt('_customStatus', 0);
      BackgroundFetch.finish(taskId);
    }
  }

  void secondTimer(taskId, duration, duration3){
    var t;
    Timer.periodic(Duration(seconds: 1), (timer2) async {
      if(timer2.tick >= duration + 3){
        timer2.cancel();
        t = DateTime.now();
        // await singleNotification("Second Command", DateFormat('hh:mm:ss').format(t).toString(), 002);
        print(FlutterBackground.isBackgroundExecutionEnabled);
        print('SECOND COMMAND::::::::::::${DateFormat('hh:mm:ss').format(t)}:::::::::::');
        updateHistory(int.parse(_duration[1]), global_customProgram[1]['program']);
        await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
        print(global_customProgram.length);
        if(global_customProgram.length > 2){
          global_customProgramIndex = global_customProgramIndex + 1;
          // prefs.setInt('_controller', global_customProgramIndex);
          prefs.setInt('_controller', 2);
          Future.delayed(const Duration(seconds: 3), () async {
            await sendRequest(global_customProgram[global_customProgramIndex]['program'], true);
            // if(prefs.getBool('_onBackground') == false){
            //   _controller[2].resume();
            // }
            print("THIRD DURATION===== $duration");
            thirdTimer(taskId, duration3);
          });
        } else {
          prefs.setInt('_controller', 0);
          BackgroundFetch.finish(taskId);
        }
      } else if(prefs.getBool('_isPause') == true) {
        timer2.cancel();
        print('isPause');
        global_customProgram[1]['duration'] = "${int.parse(global_customProgram[1]['duration']) - timer2.tick}";
      } else {
        // print('else');
        print('timer2==== ${timer2.tick}');
        _time = timer2.tick;
      }
    });
  }

  void thirdTimer(taskId , duration) {
    var t;
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if(timer.tick >= duration){
        timer.cancel();
        t = DateTime.now();
        print(FlutterBackground.isBackgroundExecutionEnabled);
        print('THIRD COMMAND:::::::::::::${DateFormat('hh:mm:ss').format(t)}::::::::::');
        // await singleNotification(
        //   "Third Command",
        //   DateFormat('hh:mm:ss').format(t).toString(),
        //   003,
        // );
        updateHistory(int.parse(_duration[2]), global_customProgram[2]['program']);
        _time = duration;
        // prefs.setInt('_time', duration);
        await sendRequest(global_customProgram[global_customProgramIndex]['program'], false);
        prefs.setInt('_controller', 0);
        // setState(() {
        //   _isPause = true;
        // });
        prefs = await SharedPreferences.getInstance();
        prefs.setInt('_customStatus', 0);
        prefs.setInt('_controller', 0);
        prefs.setString('_firstDuration', '0');
        if(prefs.getBool('_onBackground') == false){
          Navigator.pop(context);
        }
        BackgroundFetch.finish(taskId);
      } else if(prefs.getBool('_isPause') == true) {
        timer.cancel();
        global_customProgram[2]['duration'] = "${int.parse(global_customProgram[2]['duration']) - timer.tick}";
      } else {
        print('timer3==== ${timer.tick}');
        _time = timer.tick;
        // await progressNotification("Third Timer $_time", DateFormat('hh:mm:ss').format(t).toString(), 030, true);
        // prefs.setInt('_time', timer.tick);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    BackgroundFetch.finish(prefs.getString('taskId'));
    super.dispose();
  }
}