// import 'dart:async';
// import 'dart:isolate';

// import 'package:flutter/material.dart';
// import 'package:flutter_beep/flutter_beep.dart';
// import 'package:android_alarm_manager/android_alarm_manager.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await AndroidAlarmManager.initialize();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// void printHello() {
//   FlutterBeep.beep();
//   AndroidAlarmManager.cancel(0);
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter;
//   DateTime startTime;
//   DateTime beepTime;
//   Duration remainingTime;
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   init() {
//     _counter = 0;
//   }

//   Future<void> _incrementCounter() async {
//     _counter = _counter + 1;
//     setState(() {
//       startTime = DateTime.now();
//       print(startTime);
//       beepTime = startTime.add(new Duration(seconds: 60));
//     });
//     await AndroidAlarmManager.oneShotAt(beepTime, 0, printHello,
//         allowWhileIdle: true, exact: true, alarmClock: true);
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         DateTime now = DateTime.now();
//         remainingTime = beepTime.difference(now);
//       });
//       if (remainingTime.toString().contains('-')) {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'you will listen the beep after 1 minute you hit the blue button at the bottom right either app is open or in the background',
//             ),
//             Text(startTime.toString()),
//             Text(beepTime.toString()),
//             Text(remainingTime.toString()),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
