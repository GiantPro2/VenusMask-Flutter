import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUs createState() => new _ContactUs();
}

class _ContactUs extends State<ContactUs> {
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "We hope you love your Venus Mask as much as we do. If you are having any issues then please go to our support site at 'venus-mask.com/support' for all the step by step guides as well as F.A.Q.",
            style: TextStyle(fontSize: 20),
          ).paddingAll(20),
          Text("You can also email us at support@venus-mask.com"),
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
}
