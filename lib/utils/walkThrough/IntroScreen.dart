import 'package:flutter_app_esp32_dust_sensor/screens/bottomnavigation.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/bluetooth/DiscoveryPage.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/connection.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/walkThrough/dots_indicator/src/dots_decorator.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/walkThrough/dots_indicator/src/dots_indicator.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Walkthrough.dart';

class IntroScreen extends StatefulWidget {
  final List<Walkthrough> walkthroughList;
  final MaterialPageRoute pageRoute;

  IntroScreen(this.walkthroughList, this.pageRoute);

  void skipPage(BuildContext context) {
    Navigator.push(context, pageRoute);
  }

  @override
  IntroScreenState createState() {
    return new IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == widget.walkthroughList.length - 1) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: PageView(
                children: widget.walkthroughList,
                controller: controller,
                onPageChanged: _onPageChanged),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                DotsIndicator(
                  dotsCount: 3,
                  position: currentPage,
                  decorator: DotsDecorator(
                      size: const Size.square(5.0),
                      activeSize: const Size.square(8.0),
                      color: t1_view_color,
                      activeColor: t1_colorPrimary),
                ),
                SizedBox(height: height * 0.07),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: t1_colorPrimary, shape: BoxShape.circle),
                    child: Text("Skip",
                        style: TextStyle(color: t1_white, fontSize: 12.0)),
                    padding: EdgeInsets.all(24),
                  ),
                  onTap: () async {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     // builder: (context) => T2BottomNavigation(),T1WalkThrough
                    //     // builder: (context) => T2BottomNavigation(),
                    //     builder: (context) => Connection(),
                    //   ),
                    // );

                    // final BluetoothDevice selectedDevice =
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                          // return T2BottomNavigation();
                        },
                      ),
                    );

                    // if (selectedDevice != null) {
                    //   print('Discovery -> selected ' + selectedDevice.address);
                    // } else {
                    //   print('Discovery -> no device selected');
                    // }
                    // await _startConnect(selectedDevice.address);
                  },
                ),
                SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[]),
                Image.asset("assets/t1_walk_bottom.png",
                    width: width, height: height * 0.12, fit: BoxFit.fill),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void info() {
  var currentPage;
  switch (currentPage) {
    case 0:
      Container(
          margin: new EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: Image.asset("assets/t1_walk_top",
              width: 40, height: 40, alignment: Alignment.topRight));
      break;
    case 1:
      Image.asset("assets/t1_walk_top", width: 40, height: 40);
      break;
    case 2:
      Container(
          margin: new EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Image.asset("assets/t1_walk_top", width: 40, height: 40));
      break;
  }
}
