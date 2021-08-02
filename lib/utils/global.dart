import 'dart:io';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

String global_currentProgram;

String global_duration;

String global_redHistory;
String global_blueHistory;
String global_greenHistory;
String global_yellowHistory;
String global_purpleHistory;
String global_turquoiseHistory;
String global_whiteHistory;

List<Map<String, dynamic>> global_customProgram = [];

bool global_customProgramFlag;
int global_customProgramIndex;
Socket global_socket;

const BaseUrl = 'https://iqonic.design/themeforest-images/prokit';
const t1_walk3 = "$BaseUrl/images/theme1/t1_walk3.png";
const t1_walk1 = "$BaseUrl/images/theme1/t1_walk3.png";
const t1_walk2 = "$BaseUrl/images/theme1/t1_walk3.png";

String global_selectedDevice;

BluetoothConnection global_connection;
