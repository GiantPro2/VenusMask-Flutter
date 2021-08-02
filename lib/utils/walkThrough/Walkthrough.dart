import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/T1Colors.dart';
import 'package:flutter_app_esp32_dust_sensor/utils/widget.dart';

class Walkthrough extends StatefulWidget {
  final title;
  final content;
  final imageIcon;
  final imagecolor;

  Walkthrough(
      {this.title,
      this.content,
      this.imageIcon,
      this.imagecolor = Colors.redAccent});

  @override
  WalkthroughState createState() {
    return new WalkthroughState();
  }
}

class WalkthroughState extends State<Walkthrough>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: height / 15),
          text(widget.title,
              fontSize: 24.0,
              fontFamily: 'Semibold',
              textColor: t1_colorPrimary),
          SizedBox(height: height / 30),
          // CachedNetworkImage(
          //     imageUrl: widget.imageIcon,
          //     width: height * 0.35,
          //     height: height * 0.35),
//          Image.asset(widget.imageIcon, width: height * 0.35, height: height * 0.35),
          SizedBox(height: height / 30),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: text(widget.content,
                  maxLine: 2, fontSize: 16.0, isCentered: true))
        ],
      ),
    );
  }
}
