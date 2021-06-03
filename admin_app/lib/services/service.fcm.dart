// Replace with server token from firebase console settings.
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:obs_admin/util/config.dart';

// final String serverToken = '<Server-Token>';
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

// Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
//   await firebaseMessaging.requestNotificationPermissions(
//     const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
//   );

//   await post(
//     'https://fcm.googleapis.com/fcm/send',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverToken',
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{'body': 'this is a body', 'title': 'this is a title'},
//         'priority': 'high',
//         'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
//         'to': await firebaseMessaging.getToken(),
//       },
//     ),
//   );

//   final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

//   firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       completer.complete(message);
//     },
//   );

//   return completer.future;
// }

Future sendNotification(String userId, String title, String message) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> ds = await FirebaseFirestore.instance.collection("fcm").doc(userId).get();
    if (ds.data()["token"] != null) {
      String token = ds.data()["token"];
      await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken', // replace $serverToken with your firebase messaging server token
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '${Random().nextInt(100)}', 'status': 'done', 'view': 'orders'},
            'to': token,
          },
        ),
      );
    } else {
      print("unable to fetch admin device token from database");
    }
  } catch (e) {
    print("Error in sending notification");
    print(e);
  }
}

Future createAndUploadDeviceID(String userid) async {
  try {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // firebaseMessaging.requestNotificationPermissions();
    // firebaseMessaging.configure();
    String token = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection("fcm").doc(userid).set({
      "token": token,
    });
  } catch (e) {
    print("XXXXXXXXXX error on createAndUploadDeviceID");
    print(e);
    return null;
  }
}
