import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/global.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Statistics extends StatefulWidget {
  @override
  _Statistics createState() => new _Statistics();
}

class _Statistics extends State<Statistics> {
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      global_redHistory = prefs.getString('global_redHistory') ?? '0';
      global_blueHistory = prefs.getString('global_blueHistory') ?? '0';
      global_greenHistory = prefs.getString('global_greenHistory') ?? '0';
      global_yellowHistory = prefs.getString('global_yellowHistory') ?? '0';
      global_purpleHistory = prefs.getString('global_purpleHistory') ?? '0';
      global_turquoiseHistory =
          prefs.getString('global_turquoiseHistory') ?? '0';
      global_whiteHistory = prefs.getString('global_whiteHistory') ?? '0';
    });
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
          ).paddingTop(20),
          Container(
            width: size.width,
            height: size.width * 0.8,
            child: charts.BarChart(
              _createSampleData(),
              animate: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon.png',
                height: size.height * 0.15,
              )
            ],
          ).paddingAll(20)
        ],
      ),
    ));
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('Red', int.parse(global_redHistory)),
      new OrdinalSales('Blue', int.parse(global_blueHistory)),
      new OrdinalSales('Green', int.parse(global_greenHistory)),
      new OrdinalSales('Yellow', int.parse(global_yellowHistory)),
      new OrdinalSales('Purple', int.parse(global_purpleHistory)),
      new OrdinalSales('Turquoise', int.parse(global_turquoiseHistory)),
      new OrdinalSales('White', int.parse(global_whiteHistory)),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (OrdinalSales segment, _) {
          switch (segment.year) {
            case "Red":
              {
                return charts.MaterialPalette.red.shadeDefault;
              }

            case "Blue":
              {
                return charts.MaterialPalette.blue.shadeDefault;
              }

            case "Green":
              {
                return charts.MaterialPalette.green.shadeDefault;
              }

            case "Yellow":
              {
                return charts.MaterialPalette.yellow.shadeDefault;
              }

            case "White":
              {
                return charts.MaterialPalette.gray.shadeDefault;
              }

            case "Purple":
              {
                return charts.MaterialPalette.purple.shadeDefault;
              }
            case "Turquoise":
              {
                return charts.MaterialPalette.cyan.shadeDefault;
              }

            default:
              {
                return charts.MaterialPalette.red.shadeDefault;
              }
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
