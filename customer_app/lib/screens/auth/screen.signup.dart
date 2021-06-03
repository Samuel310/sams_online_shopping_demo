import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/screens/auth/screen.login_check.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/services/service.auth.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  final Response fbResponse;
  SignupScreen({this.fbResponse});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController nameController;
  bool isPasswordVisible;

  bool showLoading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    isPasswordVisible = false;
    super.initState();
    if (this.widget.fbResponse != null) {
      emailController.text = json.decode(this.widget.fbResponse.body)['email'];
      nameController.text = json.decode(this.widget.fbResponse.body)['name'];
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double dheight = MediaQuery.of(context).size.height;
    if (this.widget.fbResponse != null) {
      print('xxx from register screen ${this.widget.fbResponse.body}');
    }
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: dheight * 0.35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/signup_banner.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  "Create An Account",
                  style: TextStyle(fontSize: 15, fontFamily: PoppinsSemiBold, color: Color(0xffF84877), fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Sign up to get started and experience great shopping deals",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xff707070), fontFamily: PoppinsMedium),
                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: nameController,
                                style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 10, top: 5)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              OMIcons.person,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: emailController,
                                style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 10, top: 5)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              OMIcons.email,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: passwordController,
                                style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 10, top: 5),
                                ),
                                obscureText: !isPasswordVisible,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                isPasswordVisible ? OMIcons.visibility : OMIcons.visibilityOff,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                togglePasswordVisibility();
                              })
                        ],
                      ),
                    ),
                  ),
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
                        onSignupButtonClicked();
                      },
                      child: showLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: SpinKitChasingDots(color: Colors.white, size: 20.0),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium),
                            ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Are you already a member?", style: TextStyle(color: Colors.black, fontFamily: PoppinsRegular, fontSize: 12)),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Log In", style: TextStyle(color: Colors.black, fontFamily: PoppinsSemiBold, fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSignupButtonClicked() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && !showLoading) {
      setState(() {
        showLoading = !showLoading;
      });
      FirebaseAuthService firebaseAuthService = FirebaseAuthService();
      String res;
      if (this.widget.fbResponse != null) {
        res = await firebaseAuthService.registerWithEmailAndPassword(nameController.text, emailController.text, passwordController.text,
            profileUrl: json.decode(this.widget.fbResponse.body)['picture']['data']['url']);
      } else {
        res = await firebaseAuthService.registerWithEmailAndPassword(nameController.text, emailController.text, passwordController.text);
      }
      setState(() {
        showLoading = !showLoading;
      });
      if (res != null) {
        Fluttertoast.showToast(
          msg: res,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginChecker()), (Route<dynamic> route) => false);
      }
    } else {
      String errorMsg;
      if (nameController.text.isEmpty && emailController.text.isEmpty && passwordController.text.isEmpty) {
        errorMsg = "Enter all fields to login";
      } else if (emailController.text.isEmpty) {
        errorMsg = "Email is empty";
      } else if (passwordController.text.isEmpty) {
        errorMsg = "Password is empty";
      } else if (nameController.text.isEmpty) {
        errorMsg = "Password is empty";
      } else {
        errorMsg = "conditional error occured";
      }
      Fluttertoast.showToast(msg: errorMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
    }
  }
}
