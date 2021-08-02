import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/contactus.dart';
// import 'package:flutter_app_esp32_dust_sensor/screens/pages/contactus.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/home.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/setup.dart';
import 'package:flutter_app_esp32_dust_sensor/screens/pages/statistics.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T2BubbleBotoomBar.dart';

class T2BottomNavigation extends StatefulWidget {
  static var tag = "/T2BottomNavigation";

  @override
  T2BottomNavigationState createState() => T2BottomNavigationState();
}

class T2BottomNavigationState extends State<T2BottomNavigation> {
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    print(index);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Home(),
      Setup(),
      Statistics(),
      ContactUs(),
      // ContactUs(),
    ];
    var title = '';
    if (currentIndex == 0) {
      title = 'Home';
    } else if (currentIndex == 1) {
      title = 'Setup';
    } else if (currentIndex == 2) {
      title = 'Statistics';
    } else if (currentIndex == 3) {
      title = 'Contact Us';
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: Text(title),
        //   automaticallyImplyLeading: false,
        // ),
        body: tabs[currentIndex],
        bottomNavigationBar: BubbleBottomBar(
          opacity: .2,
          currentIndex: currentIndex,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 8,
          onTap: changePage,
          hasNotch: false,
          hasInk: true,
          items: <BubbleBottomBarItem>[
            tab(Icons.dashboard, "Home"),
            tab(Icons.settings, "Setup"),
            tab(Icons.equalizer, "Statistics"),
            tab(Icons.contact_mail, "Contact Us"),
          ],
        ),
      ),
    );
  }
}
