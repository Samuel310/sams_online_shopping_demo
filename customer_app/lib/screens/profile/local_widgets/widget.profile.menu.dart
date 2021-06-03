import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/screens/orders/screen.order.dart';
import 'package:oyil_boutique/screens/profile/screen.shipping.address.dart';
import 'package:oyil_boutique/services/service.auth.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';

Widget profileMenu({User user, BuildContext context}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(width: 1, color: Color(0xffE2E4E8)),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      // boxShadow: <BoxShadow>[
      //   new BoxShadow(
      //     color: Colors.grey,
      //     blurRadius: 10,
      //     offset: new Offset(0.0, 0.0),
      //   ),
      // ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        children: [
          Visibility(
            visible: user != null,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen(user: user)));
                },
                child: singleItemWidget(icon: OMIcons.formatListBulleted, title: "All My Orders"),
              ),
            ),
          ),
          Visibility(
            visible: user != null,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingAddressScreen(user: user)));
                },
                child: singleItemWidget(icon: OMIcons.whereToVote, title: "Shipping Address"),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Contact Us"),
                    content: Text("Contact directly through whatsapp"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Cancel", style: TextStyle(color: Color(0xffF84877))),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          if (adminContactDetail != null) {
                            launchWhatsApp(message: "", phone: adminContactDetail.phone);
                          } else {
                            showToast("Unable to contact at the moment", Colors.red);
                          }
                        },
                        child: Text("Ok", style: TextStyle(color: Color(0xffF84877))),
                      ),
                    ],
                  ),
                );
              },
              child: singleItemWidget(icon: OMIcons.headsetMic, title: "Contact Us"),
            ),
          ),
          Visibility(
            visible: user != null,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {},
                child: singleItemWidget(icon: OMIcons.nearMe, title: "Invite Friends"),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {},
              child: singleItemWidget(icon: OMIcons.stars, title: "Rate Our App"),
            ),
          ),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {},
              child: singleItemWidget(icon: OMIcons.verifiedUser, title: "Privacy Policy"),
            ),
          ),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {},
              child: singleItemWidget(icon: OMIcons.playlistAddCheck, title: "Terms & Conditions", showBottomLine: user != null ? true : false),
            ),
          ),
          Visibility(
            visible: user != null,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  FirebaseAuthService().signOut();
                },
                child: singleItemWidget(icon: OMIcons.exitToApp, title: "Logout", showBottomLine: false),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget singleItemWidget({IconData icon, String title, bool showBottomLine = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Icon(
          icon,
          color: Color(0xff727C8E),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 45,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: showBottomLine ? Color(0xffE2E4E8) : Colors.white, width: 1))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(title, style: TextStyle(fontFamily: PoppinsRegular, fontSize: 15, color: Color(0xff515C6F))),
                ),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffE2E4E8)),
                  child: Center(
                    child: Icon(
                      OMIcons.chevronRight,
                      color: Color(0xff727C8E),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    ),
  );
}
