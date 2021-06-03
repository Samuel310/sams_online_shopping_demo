import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oyil_boutique/models/modal.checkout.dart';
import 'package:oyil_boutique/models/models.address.dart';
import 'package:oyil_boutique/screens/auth/screen.login.dart';
import 'package:oyil_boutique/screens/checkout/screens.add.address.dart';
import 'package:oyil_boutique/screens/checkout/screens.checkout.address.list.dart';
import 'package:oyil_boutique/screens/checkout/screens.email.verification.dart';
import 'package:oyil_boutique/services/service.checkout.dart';
import 'package:provider/provider.dart';

class CheckoutWrapperScreen extends StatelessWidget {
  final CheckoutModel checkoutProduct;
  final List<CheckoutModel> checkoutProductList;
  CheckoutWrapperScreen({this.checkoutProduct, this.checkoutProductList});

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    if (user == null) {
      return LoginScreen();
    } else if (!user.emailVerified) {
      return EmailVerificationScreen(user: user);
    } else {
      return FutureBuilder(
        future: CheckOutDatabaseService().getAllAddress(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<ShippingAddress> list;
            try {
              list = snapshot.data;
            } catch (e) {
              print(e);
            }
            if (list == null || list.isEmpty) {
              if (checkoutProductList != null) {
                return AddAddress(checkoutProductList: checkoutProductList, user: user);
              } else {
                return AddAddress(checkoutProduct: checkoutProduct, user: user);
              }
            } else {
              if (checkoutProductList != null) {
                return CheckoutAddressList(user: user, shippingAddressList: list, checkoutProductList: checkoutProductList);
              } else {
                return CheckoutAddressList(checkoutProduct: checkoutProduct, user: user, shippingAddressList: list);
              }
            }
          } else {
            return Scaffold(
              body: Center(
                child: SpinKitChasingDots(
                  color: Color(0xffF84877),
                  size: 40.0,
                ),
              ),
            );
          }
        },
      );
    }
  }
}
