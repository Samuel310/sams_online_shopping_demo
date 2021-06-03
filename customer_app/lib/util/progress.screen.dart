import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressScreen extends StatefulWidget {
  void dismissProgress(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    //const horizontal = MediaQuery.of(context).size.width * 0.3;

    // const l = horizontal;
    // const t = MediaQuery.of(context).size.height * 0.3;
    // const r = MediaQuery.of(context).size.width * 0.3;
    // const b = MediaQuery.of(context).size.height * 0.30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
              // width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: SpinKitChasingDots(
                    color: Color(0xffF84877),
                    size: 25.0,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
