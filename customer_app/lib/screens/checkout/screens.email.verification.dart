import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/services/service.auth.dart';
import 'package:oyil_boutique/util/constants.dart';

class EmailVerificationScreen extends StatelessWidget {
  final User user;
  EmailVerificationScreen({this.user});

  final FirebaseAuthService authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: FutureBuilder(
              future: authService.sendEmailVerificationLink(user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'success') {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffffeeef)),
                            child: Icon(
                              OMIcons.mail,
                              color: Color(0xffF84877),
                              size: 35,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Verify Your Email",
                          style: TextStyle(fontFamily: PoppinsSemiBold, fontSize: 24, color: Colors.black),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Before proceeding to checkout, Please verify your email address. Email verification link has been sent to your registered email address.",
                            style: TextStyle(fontFamily: PoppinsRegular, fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: Color(0xffF84877),
                                ),
                                onPressed: () async {
                                  await authService.signOut();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: snapshot.data, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
                    Navigator.pop(context);
                    return Center(
                      child: SpinKitChasingDots(
                        color: Color(0xffF84877),
                        size: 40.0,
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: SpinKitChasingDots(
                      color: Color(0xffF84877),
                      size: 40.0,
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}
