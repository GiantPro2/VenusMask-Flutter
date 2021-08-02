import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'dart:ui';

// import 'package:flutter_blue/flutter_blue.dart';

Widget text(var text,
    {var fontSize = 18.0,
    textColor = const Color(0xFF747474),
    var fontFamily = 'Regular',
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.5}) {
  return Text(
    text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: maxLine,
    style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = t1_white,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: shadow_color, blurRadius: 2, spreadRadius: 2)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

changeStatusColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        useWhiteForeground(color));
  } on Exception catch (e) {
    print(e);
  }
}

Widget ring(String description) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150.0),
          border: Border.all(
            width: 16.0,
            color: t2_colorPrimary,
          ),
        ),
      ),
      SizedBox(height: 16),
      text(description,
          textColor: t2TextColorPrimary,
          fontSize: 20.0,
          fontFamily: 'Semibold',
          isCentered: true,
          maxLine: 2)
    ],
  );
}

// ignore: must_be_immutable
class RoundButton extends StatelessWidget {
  Color backgroundColor;
  Color borderColor;
  bool borderFlag;
  VoidCallback onPressed;
  RoundButton(Color backgroundColor, Color borderColor, bool borderFlag,
      VoidCallback onPressed) {
    this.backgroundColor = backgroundColor;
    this.borderColor = borderColor;
    this.borderFlag = borderFlag;
    this.onPressed = onPressed;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: borderFlag
          ? BoxDecoration(border: Border.all(color: Colors.blueAccent))
          : BoxDecoration(),
      child: ButtonTheme(
        minWidth: 30,
        height: 30,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: borderColor)),
          color: backgroundColor,
          textColor: backgroundColor,
          padding: EdgeInsets.all(8.0),
          onPressed: onPressed,
          child: Text(
            "".toUpperCase(),
            style: TextStyle(
              fontSize: 4.0,
            ),
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  var titleName;
  Color bgColor;

  TopBar(var this.titleName, {this.bgColor = Colors.white});

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        color: widget.bgColor ?? Colors.transparent,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                back(context);
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Center(child: headerText(widget.titleName)),
            )
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

back(var context) {
  Navigator.pop(context);
}

Text headerText(var text) {
  return Text(
    text,
    maxLines: 2,
    style:
        TextStyle(fontFamily: 'Bold', fontSize: 22, color: t2_textColorPrimary),
  );
}

// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// class ScanResultTile extends StatelessWidget {
//   const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

//   final ScanResult result;
//   final VoidCallback onTap;

//   Widget _buildTitle(BuildContext context) {
//     if (result.device.name.length > 0) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             result.device.name,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             result.device.id.toString(),
//             style: Theme.of(context).textTheme.caption,
//           )
//         ],
//       );
//     } else {
//       return Text(result.device.id.toString());
//     }
//   }

//   Widget _buildAdvRow(BuildContext context, String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(title, style: Theme.of(context).textTheme.caption),
//           SizedBox(
//             width: 12.0,
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: Theme.of(context)
//                   .textTheme
//                   .caption
//                   .apply(color: Colors.black),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String getNiceHexArray(List<int> bytes) {
//     return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
//         .toUpperCase();
//   }

//   String getNiceManufacturerData(Map<int, List<int>> data) {
//     if (data.isEmpty) {
//       return null;
//     }
//     List<String> res = [];
//     data.forEach((id, bytes) {
//       res.add(
//           '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
//     });
//     return res.join(', ');
//   }

//   String getNiceServiceData(Map<String, List<int>> data) {
//     if (data.isEmpty) {
//       return null;
//     }
//     List<String> res = [];
//     data.forEach((id, bytes) {
//       res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
//     });
//     return res.join(', ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: _buildTitle(context),
//       leading: Text(result.rssi.toString()),
//       trailing: RaisedButton(
//         child: Text('CONNECT'),
//         color: t1_colorPrimary,
//         textColor: Colors.white,
//         onPressed: (result.advertisementData.connectable) ? onTap : null,
//       ),
//       children: <Widget>[
//         _buildAdvRow(
//             context, 'Complete Local Name', result.advertisementData.localName),
//         _buildAdvRow(context, 'Tx Power Level',
//             '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
//         _buildAdvRow(
//             context,
//             'Manufacturer Data',
//             getNiceManufacturerData(
//                     result.advertisementData.manufacturerData) ??
//                 'N/A'),
//         _buildAdvRow(
//             context,
//             'Service UUIDs',
//             (result.advertisementData.serviceUuids.isNotEmpty)
//                 ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
//                 : 'N/A'),
//         _buildAdvRow(context, 'Service Data',
//             getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
//       ],
//     );
//   }
// }

// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;

//   const ServiceTile({Key key, this.service, this.characteristicTiles})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.length > 0) {
//       return ExpansionTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Service'),
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context)
//                     .textTheme
//                     .body1
//                     .copyWith(color: Theme.of(context).textTheme.caption.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return ListTile(
//         title: Text('Service'),
//         subtitle:
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }

// class CharacteristicTile extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;
//   final VoidCallback onNotificationPressed;

//   const CharacteristicTile(
//       {Key key,
//       this.characteristic,
//       this.descriptorTiles,
//       this.onReadPressed,
//       this.onWritePressed,
//       this.onNotificationPressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<int>>(
//       stream: characteristic.value,
//       initialData: characteristic.lastValue,
//       builder: (c, snapshot) {
//         final value = snapshot.data;
//         return ExpansionTile(
//           title: ListTile(
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Characteristic'),
//                 Text(
//                     '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//                     style: Theme.of(context).textTheme.body1.copyWith(
//                         color: Theme.of(context).textTheme.caption.color))
//               ],
//             ),
//             subtitle: Text(value.toString()),
//             contentPadding: EdgeInsets.all(0.0),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//                 ),
//                 onPressed: onReadPressed,
//               ),
//               IconButton(
//                 icon: Icon(Icons.file_upload,
//                     color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//                 onPressed: onWritePressed,
//               ),
//               IconButton(
//                 icon: Icon(
//                     characteristic.isNotifying
//                         ? Icons.sync_disabled
//                         : Icons.sync,
//                     color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//                 onPressed: onNotificationPressed,
//               )
//             ],
//           ),
//           children: descriptorTiles,
//         );
//       },
//     );
//   }
// }

// class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;

//   const DescriptorTile(
//       {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Descriptor'),
//           Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//               style: Theme.of(context)
//                   .textTheme
//                   .body1
//                   .copyWith(color: Theme.of(context).textTheme.caption.color))
//         ],
//       ),
//       subtitle: StreamBuilder<List<int>>(
//         stream: descriptor.value,
//         initialData: descriptor.lastValue,
//         builder: (c, snapshot) => Text(snapshot.data.toString()),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }

// class AdapterStateTile extends StatelessWidget {
//   const AdapterStateTile({Key key, @required this.state}) : super(key: key);

//   final BluetoothState state;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.redAccent,
//       child: ListTile(
//         title: Text(
//           'Bluetooth adapter is ${state.toString().substring(15)}',
//           style: Theme.of(context).primaryTextTheme.subhead,
//         ),
//         trailing: Icon(
//           Icons.error,
//           color: Theme.of(context).primaryTextTheme.subhead.color,
//         ),
//       ),
//     );
//   }
// }
