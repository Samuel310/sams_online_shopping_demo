import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:oyil_boutique/util/progress.screen.dart';
import 'package:url_launcher/url_launcher.dart';

void showProgressDialog(BuildContext context, ProgressScreen ps) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ps;
    },
  );
}

void dismissProgressDialog(BuildContext context, ProgressScreen ps) {
  ps.dismissProgress(context);
}

Future getCityAndCountry(String pincode) async {
  try {
    Response response = await get(Uri.parse('http://www.postalpincode.in/api/pincode/$pincode'));
    if (json.decode(response.body)['Status'] != 'Error') {
      String city = json.decode(response.body)['PostOffice'][0]['District'];
      String state = json.decode(response.body)['PostOffice'][0]['State'];
      String country = json.decode(response.body)['PostOffice'][0]['Country'];
      print(city);
      print(state);
      print(country);
      return {'city': city, 'state': state, 'country': country};
    }
  } catch (e) {
    print(e);
  }
}

void showToast(String msg, Color color) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: color, textColor: Colors.white, fontSize: 12.0);
}

void launchWhatsApp({@required String phone, @required String message}) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
}
