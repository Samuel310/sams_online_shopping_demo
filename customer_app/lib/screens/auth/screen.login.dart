import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/screens/auth/screen.forget_pass.dart';
import 'package:oyil_boutique/screens/auth/screen.signup.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/services/service.auth.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController;
  TextEditingController passwordController;
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
    isPasswordVisible = false;
    super.initState();
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: dheight * 0.35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/login_banner.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    "Sam's Store",
                    style: TextStyle(fontSize: 20, fontFamily: PoppinsSemiBold, color: Color(0xffF84877), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Login & Discover The Benefits",
                    style: TextStyle(fontSize: 15, fontFamily: PoppinsSemiBold, color: Color(0xffF84877), fontWeight: FontWeight.bold),
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
                                OMIcons.mail,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.black, fontFamily: PoppinsRegular, fontSize: 12),
                          ),
                        )
                      ],
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
                          onLoginButtonClicked();
                        },
                        child: showLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: SpinKitChasingDots(color: Colors.white, size: 20.0),
                              )
                            : Text(
                                'Log In',
                                style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ),
                        Text("Not a member yet?", style: TextStyle(color: Colors.grey, fontFamily: PoppinsMedium)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: dheight * 0.06,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xffF84877), width: 1), borderRadius: BorderRadius.circular(3)),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: SizedBox(
                      height: dheight * 0.06,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xffD3D3D3), width: 1), borderRadius: BorderRadius.circular(3)),
                        ),
                        onPressed: () {
                          onFbLoginBtnClicked();
                        },
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Signup with Facebook',
                                style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage("assets/images/fb_logo.png"),
                                width: dheight * 0.03,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginButtonClicked() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty && !showLoading) {
      setState(() {
        showLoading = !showLoading;
      });
      FirebaseAuthService firebaseAuthService = FirebaseAuthService();
      String res = await firebaseAuthService.signInWithEmailAndPassword(emailController.text, passwordController.text);
      setState(() {
        showLoading = !showLoading;
      });
      if (res != null) {
        Fluttertoast.showToast(msg: res, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.blue, textColor: Colors.white, fontSize: 12.0);
      } else {
        Navigator.pop(context);
      }
    } else {
      String errorMsg;
      if (emailController.text.isEmpty && passwordController.text.isNotEmpty) {
        errorMsg = "Email is empty";
      } else if (passwordController.text.isEmpty && emailController.text.isNotEmpty) {
        errorMsg = "Password is empty";
      } else {
        errorMsg = "Enter email and password to login";
      }
      Fluttertoast.showToast(msg: errorMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
    }
  }

  void onFbLoginBtnClicked() async {
    Response res = await FirebaseAuthService().loginUsingFacebook();
    if (res != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SignupScreen(
                    fbResponse: res,
                  )));
    } else {
      showToast("Unable to login using facebook", Colors.red);
    }
  }
}
