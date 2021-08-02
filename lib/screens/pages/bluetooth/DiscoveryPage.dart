import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/bottomnavigation.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/bluetooth/BluetoothDeviceListEntry.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:nb_utils/nb_utils.dart';

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  _DiscoveryPage();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: t1_colorPrimary,
        title: isDiscovering
            ? Text('Discovering devices')
            : Text('Discovered devices'),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
            onTap: () async {
              // Navigator.of(context).pop(result.device);
              await _startConnect(result.device.address);
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => T2BottomNavigation(),T1WalkThrough
                  builder: (context) => T2BottomNavigation(),
                  // builder: (context) => Connection(),
                ),
              );
            },
            onLongPress: () async {
              try {
                bool bonded = false;
                if (result.device.isBonded) {
                  print('Unbonding from ${result.device.address}...');
                  await FlutterBluetoothSerial.instance
                      .removeDeviceBondWithAddress(result.device.address);
                  print('Unbonding from ${result.device.address} has succed');
                } else {
                  print('Bonding with ${result.device.address}...');
                  bonded = await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(result.device.address);
                  print(
                      'Bonding with ${result.device.address} has ${bonded ? 'succed' : 'failed'}.');
                }
                setState(() {
                  results[results.indexOf(result)] = BluetoothDiscoveryResult(
                      device: BluetoothDevice(
                        name: result.device.name ?? '',
                        address: result.device.address,
                        type: result.device.type,
                        bondState: bonded
                            ? BluetoothBondState.bonded
                            : BluetoothBondState.none,
                      ),
                      rssi: result.rssi);
                });
              } catch (ex) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error occured while bonding'),
                      content: Text("${ex.toString()}"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
