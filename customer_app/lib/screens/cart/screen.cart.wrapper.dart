import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/cart/screen.cart.dart';
import 'package:oyil_boutique/util/constants.dart';

class CartWrapper extends StatelessWidget {
  final User user;
  CartWrapper({this.user});
  @override
  Widget build(BuildContext context) {
    return user != null
        ? CartScreen(user: user)
        : Scaffold(
            body: Center(
              child: Text("Login to manage your cart", style: TextStyle(color: Colors.grey[600], fontFamily: PoppinsMedium)),
            ),
          );
  }
}
