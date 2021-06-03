import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/global_widgets/navigation_drawer.dart';
import 'package:oyil_boutique/screens/orders/screen.order.dart';
import 'package:oyil_boutique/services/service.cart.dart';
import 'package:oyil_boutique/services/service.wishlist.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/util/push_nofitications.dart';
import 'package:provider/provider.dart';

class LoginChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
    if (user != null) {
      pushNotificationsManager.init((Map<String, dynamic> message) {
        try {
          print(message);
          String view = message['data']['view'];
          if (view != null) {
            if (view == "orders") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrdersScreen(
                            user: user,
                          )));
            }
          }
        } catch (e) {
          print("Error while onClickNotification");
          print(e);
        }
      });

      if (globalCartList.isEmpty && initialCartDataLoad) {
        return FutureBuilder(
          future: CartDatabaseService().getAllProductsInCart(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (globalWishList.isEmpty && initialWishlistDataLoad) {
                return FutureBuilder(
                  future: WishlistDatabaseService().getAllProductsInWishlist(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return NavigationDrawerScreen(user: user);
                    } else {
                      return Scaffold(
                        body: Container(
                          color: Colors.white,
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(child: Text("Sam's Store", style: TextStyle(fontSize: 40, fontFamily: PoppinsBold, color: Color(0xffF84877)), textAlign: TextAlign.center)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
              return NavigationDrawerScreen(user: user);
            } else {
              return Scaffold(
                  body: Container(
                color: Colors.white,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(child: Text("Sam's Store", style: TextStyle(fontSize: 40, fontFamily: PoppinsBold, color: Color(0xffF84877)), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ));
            }
          },
        );
      } else if (globalWishList.isEmpty && initialWishlistDataLoad) {
        return FutureBuilder(
          future: WishlistDatabaseService().getAllProductsInWishlist(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return NavigationDrawerScreen(user: user);
            } else {
              return Scaffold(
                  body: Container(
                color: Colors.white,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(child: Text("Sam's Store", style: TextStyle(fontSize: 40, fontFamily: PoppinsBold, color: Color(0xffF84877)), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ));
            }
          },
        );
      }
    }

    return NavigationDrawerScreen(user: user);
  }
}
