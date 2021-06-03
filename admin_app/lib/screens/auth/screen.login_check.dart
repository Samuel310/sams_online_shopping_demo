import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:obs_admin/screens/orders/screen.order.slider.dart';
import 'package:obs_admin/screens/screen.home.dart';
import 'package:obs_admin/screens/auth/screen.login.dart';
import 'package:obs_admin/util/push_nofitications.dart';
import 'package:provider/provider.dart';

class LoginChecker extends StatelessWidget {
  final PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    if (user != null) {
      pushNotificationsManager.init((RemoteMessage message) {
        try {
          print(message);
          String view = message.data['view'];
          if (view != null) {
            if (view == "orders") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSliderScreen()));
            }
          }
        } catch (e) {
          print("Error while onClickNotification");
          print(e);
        }
      });
    }
    return user != null ? HomeScreen() : LoginScreen();
  }
}
