import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/bluetooth/DiscoveryPage.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/bluetooth/sensor_page.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/widget.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:flutter_blue/flutter_blue.dart';

class Connection extends StatefulWidget {
  @override
  _Connection createState() => new _Connection();
}

class _Connection extends State<Connection> {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  String connectedDeviceAddress;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        results.add(r);
      });
    });
    _streamSubscription.onDone(() {
      print("done");
    });
  }

  void _startConnect(address) async {
    // Some simplest connection :F
    try {
      global_connection = await BluetoothConnection.toAddress(address);
      toast('Connected to the device');
      print('Connected to the device');

      global_connection.input.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');
        toast('Data incoming: ${ascii.decode(data)}');
        global_connection.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
          global_connection.finish(); // Closing connection
          print('Disconnecting by local host');
          toast('Disconnecting by local host');
        }
      }).onDone(() {
        print('Disconnected by remote request');
        toast('Disconnecting by remote request');
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
      toast('Cannot connect, exception occured');
    }
  }

  void sendRequest() async {
    try {
      global_connection.output.add(utf8.encode('1' + "\r\n"));
      await global_connection.output.allSent;
      toast("successfully sent");
    } catch (e) {
      // Ignore error, but notify state
      toast(e.toString());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
        // floatingActionButton: StreamBuilder<bool>(
        //   stream: FlutterBlue.instance.isScanning,
        //   initialData: false,
        //   builder: (c, snapshot) {
        //     if (snapshot.data) {
        //       return FloatingActionButton(
        //         child: Icon(Icons.stop),
        //         onPressed: () => FlutterBlue.instance.stopScan(),
        //         backgroundColor: Colors.red,
        //       );
        //     } else {
        //       return FloatingActionButton(
        //           child: Icon(Icons.search),
        //           onPressed: () => FlutterBlue.instance
        //               .startScan(timeout: Duration(seconds: 4)));
        //     }
        //   },
        // ),
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // StreamBuilder<List<ScanResult>>(
          //   stream: FlutterBlue.instance.scanResults,
          //   initialData: [],
          //   builder: (c, snapshot) => Column(
          //     children: snapshot.data
          //         .map(
          //           (r) => ScanResultTile(
          //               result: r,
          //               onTap: () async {
          //                 try {
          //                   await r.device.connect();
          //                   toast("connected successfully");
          //                 } catch (e) {
          //                   toast(e);
          //                 }
          //               }

          //               // () => Navigator.of(context)
          //               //     .push(MaterialPageRoute(builder: (context) {
          //               //   r.device.connect();
          //               //   return SensorPage(device: r.device);
          //               // })),
          //               ),
          //         )
          //         .toList(),
          //   ),
          // ),
          MaterialButton(
            textColor: white,
            color: t1_colorPrimary,
            onPressed: () async {
//                   // Start scanning
// //               flutterBlue.startScan(timeout: Duration(seconds: 4));

// // // Listen to scan results
// //               var subscription = flutterBlue.scanResults.listen((results) {
// //                 // do something with scan results
// //                 for (ScanResult r in results) {
// //                   print('${r.device.name} found! rssi: ${r.rssi}');
// //                   toast(r.toString());
// //                 }
// //               });

// // Stop scanning
//                   // flutterBlue.stopScan();
              final BluetoothDevice selectedDevice =
                  await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DiscoveryPage();
                  },
                ),
              );

              if (selectedDevice != null) {
                print('Discovery -> selected ' + selectedDevice.address);
              } else {
                print('Discovery -> no device selected');
              }
              await _startConnect(selectedDevice.address);
            },
            child: Text('connect_device'),
          ),
          MaterialButton(
            child: Text('red_on'),
            textColor: white,
            color: t1_colorPrimary,
            onPressed: () async {
              await sendRequest();
            },
          ),
        ],
      ),
    ));
  }
}
