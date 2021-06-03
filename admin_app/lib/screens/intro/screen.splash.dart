import 'dart:async';
import 'package:flutter/material.dart';
import 'package:obs_admin/screens/auth/screen.login_check.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Row(
          children: [
            Expanded(child: Text("Sam's Store", style: TextStyle(fontSize: 40, color: Color(0xffF84877)), textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, goToNextPage);
  }

  void goToNextPage() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginChecker()), (Route<dynamic> route) => false);
  }
}
