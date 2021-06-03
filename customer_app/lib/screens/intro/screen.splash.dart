import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oyil_boutique/screens/auth/screen.login_check.dart';
import 'package:oyil_boutique/services/service.shop.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/services/service.manage.orders.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // startTime();
    goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: Row(
                children: [
                  Expanded(child: Text("Sam's Store", style: TextStyle(fontSize: 40, fontFamily: PoppinsBold, color: Color(0xffF84877)), textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: 25,
                height: 25,
                child: SpinKitChasingDots(
                  color: Color(0xffF84877),
                  size: 25.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // startTime() async {
  //   var _duration = new Duration(seconds: 2);
  //   return new Timer(_duration, goToNextPage);
  // }

  void goToNextPage() async {
    ShopDatabaseService shopDatabaseService = ShopDatabaseService();
    bannersList = await shopDatabaseService.getBanners();
    featuredProducts = await shopDatabaseService.getFeaturedProduct();
    ManageOrdersService().loadAdminContactDetails();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginChecker()), (Route<dynamic> route) => false);
  }
}
