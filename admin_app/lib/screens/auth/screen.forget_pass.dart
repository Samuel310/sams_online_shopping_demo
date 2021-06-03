import 'package:flutter/material.dart';
import 'package:obs_admin/services/service.auth.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

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
    //double dheight = MediaQuery.of(context).size.height;

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
                  height: 300,
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
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 56,
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
                    height: 45,
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
                                contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                    height: 45,
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
                      ),
                    ),
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
        showToast("Password reset link has been sent to your email", Colors.green);
      } else {
        showToast(res, Colors.red);
      }
    } else {
      showToast("Email cannot be empty", Colors.red);
    }
  }
}
