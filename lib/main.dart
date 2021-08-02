import 'dart:async';
import 'dart:io';

// import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/splash.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:nb_utils/nb_utils.dart';

// void _backgroundTaskEntrypoint() async {
//   AudioServiceBackground.run(() => AudioPlayerTask());
// }

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await AndroidAlarmManager.initialize();
  // try {
  //   Socket sock = await Socket.connect('192.168.4.1', 80);
  //   global_socket = sock;
  // } catch (e) {
  //   print(e);
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeNotifications() async {
    var initializeAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializeIOS = IOSInitializationSettings();
    var initSettings =
        InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venus Mask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Nunito'),
      home: Splash(),
      // home: AppView(),
    );
  }
}

// class AppView extends StatelessWidget {
//   start() async {
//     await AudioService.connect();
//     AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
//   }
//
//   play() async {
//     AudioService.play();
//   }
//
//   pause() async {
//     AudioService.pause();
//   }
//
//   stop() => AudioService.stop();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Audio Demo"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//
//             ElevatedButton(child: Text("Start"), onPressed: start,),
//
//             ElevatedButton(child: Text("Play"), onPressed: play),
//
//             ElevatedButton(child: Text("pause"), onPressed: pause),
//
//             ElevatedButton(child: Text("Stop"), onPressed: stop),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){},
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';

// void main() async {
//   // modify with your true address/port
//   Socket sock = await Socket.connect('192.168.4.1', 80);
//   runApp(MyApp(sock));
// }

// class MyApp extends StatelessWidget {
//   Socket socket;

//   MyApp(Socket s) {
//     this.socket = s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = 'TcpSocket Demo';
//     return MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//         channel: socket,
//       ),
//     );
//   }
// }

//   void _yellowOn() {
//     widget.channel.write("YellowOn\n");
//   }

//   void _purpleOn() {
//     widget.channel.write("PurpleOn\n");
//   }

//   void _turquoiseOn() {
//     widget.channel.write("TurquoiseOn\n");
//   }

//   void _whiteOn() {
//     widget.channel.write("WhiteOn\n");
//   }

//   void _allOff() {
//     widget.channel.write("AllOff\n");
//   }

//   @override
//   void dispose() {
//     widget.channel.close();
//     super.dispose();
//   }
// }

// class AudioPlayerTask extends BackgroundAudioTask {
//   final _audioPlayer = AudioPlayer();
//   // static const streamUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
//
//   @override
//   Future<void> onStart(Map<String, dynamic> params) async {
//     AudioServiceBackground.setState(
//     //     controls: [MediaControl.pause, MediaControl.stop],
//         playing: true,
//         processingState: AudioProcessingState.connecting);
//     // Connect to the URL\
//     await _audioPlayer.setUrl("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3");
//
//     // Now we're ready to play
//     _audioPlayer.play();
//     // Broadcast that we're playing, and what controls are available.
//     AudioServiceBackground.setState(
//         // controls: [MediaControl.pause, MediaControl.stop],
//         playing: true,
//         processingState: AudioProcessingState.ready);
//   }
//
//   @override
//   Future<void> onStop() async {
//     // Stop playing audio.
//     _audioPlayer.stop();
//     // Broadcast that we've stopped.
//     await AudioServiceBackground.setState(
//         playing: false,
//         processingState: AudioProcessingState.stopped);
//     // Shut down this background task
//     await super.onStop();
//   }
//
//   @override
//   Future<void> onPlay() async {
//     // Broadcast that we're playing, and what controls are available.
//     AudioServiceBackground.setState(
//     //     controls: [MediaControl.pause, MediaControl.stop],
//         playing: true,
//         processingState: AudioProcessingState.ready);
//     // Start playing audio.
//   }
//
//   @override
//   Future<void> onPause() async {
//     // Broadcast that we're paused, and what controls are available.
//     AudioServiceBackground.setState(
//     //     controls: [MediaControl.play, MediaControl.stop],
//         playing: false,
//         processingState: AudioProcessingState.ready);
//     // Pause the audio.
//     await _audioPlayer.pause();
//   }
// }
