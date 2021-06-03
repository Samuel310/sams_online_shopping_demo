import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/profile/screen.no.user.dart';
import 'package:oyil_boutique/screens/profile/screen.user.dart';

class ProfileScreenWrapper extends StatelessWidget {
  final User user;
  ProfileScreenWrapper({this.user});
  @override
  Widget build(BuildContext context) {
    return (user == null) ? NoUserScreen() : UserScreen(user: user);
  }
}
