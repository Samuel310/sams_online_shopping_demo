import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/wishlist/screen.wishlist.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:provider/provider.dart';

class WishListWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return user != null
        ? WishListScreen(user: user)
        : Scaffold(
            backgroundColor: Color(0xffF84877),
            body: SafeArea(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text("Login to manage your wishlist", style: TextStyle(color: Colors.grey[600], fontFamily: PoppinsMedium)),
                ),
              ),
            ),
          );
  }
}
