import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:obs_admin/util/common.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init(Function onClickNotification) async {
    if (!_initialized) {
      // For iOS request permission first.
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          showToast("New Order Has Been Placed", Colors.blue);
          onClickNotification(message);
        }
      });
      // _firebaseMessaging.configure(
      //   // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   //   onClickNotification(message);
      //   // },
      //   onLaunch: (Map<String, dynamic> message) async {
      //     onClickNotification(message);
      //   },
      //   onMessage: (Map<String, dynamic> message) async {
      //     showToast("New Order Has Been Placed", Colors.blue);
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     onClickNotification(message);
      //   },
      // );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}
