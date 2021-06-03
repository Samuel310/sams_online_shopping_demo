import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/screens/auth/screen.login_check.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/services/service.auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: dheight * 0.35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/forgotpassword_banner.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Forgot Your Password?",
                  style: TextStyle(fontSize: 15, fontFamily: PoppinsSemiBold, color: Color(0xffF84877), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Enter your registered email and recover your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xff707070), fontFamily: PoppinsMedium),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: dheight * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Color(0xffD3D3D3), width: 1),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                border: InputBorder.none,
                                //contentPadding: EdgeInsets.only(bottom: dheight * 0.02, left: 10, right: 10, top: dheight * 0.01)
                                contentPadding: EdgeInsets.only(bottom: 10, top: 5, left: 10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              OMIcons.mail,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: dheight * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffF84877),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        ),
                        onPressed: () {
                          onResetButtonClisked();
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onResetButtonClisked() async {
    if (emailController.text.isNotEmpty) {
      String res = await FirebaseAuthService().resetPassword(emailController.text);
      if (res == null) {
        showSuccessAlert();
      } else {
        Fluttertoast.showToast(msg: res, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Email cannot be empty", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
    }
  }

  void showSuccessAlert() {
    Alert(
      context: context,
      type: AlertType.success,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(color: Colors.black, fontFamily: PoppinsRegular, fontSize: 12),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color(0xffF84877),
          ),
        ),
      ),
      title: "Password reset link has been sent to your email address.",
      buttons: [
        DialogButton(
          color: Color(0xffF84877),
          child: Text(
            "Log In",
            style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: PoppinsRegular),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginChecker()), (Route<dynamic> route) => false);
          },
          width: 100,
          height: 35,
        )
      ],
    ).show();
  }
}
