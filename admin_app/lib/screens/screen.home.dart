import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:obs_admin/screens/analytics/screen.analytics.slider.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/orders/screen.order.slider.dart';
import 'package:obs_admin/screens/products/screen.product.category.dart';
import 'package:obs_admin/util/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffF84877),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 56, bottom: 65),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              homepageMenuBox(context, 'assets/images/products_logo.png', PRODUCTS),
                              homepageMenuBox(context, 'assets/images/orders_logo.png', ORDERS),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              homepageMenuBox(context, 'assets/images/customize_logo.png', CUSTOM),
                              homepageMenuBox(context, 'assets/images/products_logo.png', ANALYTICS),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(left: 20),
                          //       child: homepageMenuBox(context, 'assets/images/customize_logo.png', CUSTOM),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                appBar(title: "Welcome", context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget homepageMenuBox(BuildContext context, String image, String title) {
    return Container(
      height: MediaQuery.of(context).size.width / 2 - 30,
      width: MediaQuery.of(context).size.width / 2 - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 3.0, offset: new Offset(0.0, 1.0))],
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          onTap: () {
            onHomepageMenuBoxClicked(context, title);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage(image), width: 35, height: 35),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 14, fontFamily: PoppinsRegular)),
            ],
          ),
        ),
      ),
    );
  }

  void onHomepageMenuBoxClicked(BuildContext context, String title) {
    switch (title) {
      case PRODUCTS:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductCategoryScreen()));
        break;
      case ORDERS:
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSliderScreen()));
        break;
      case CUSTOM:
        print("go to custom page");
        break;
      case ANALYTICS:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsSliderScreen()));
        break;
      default:
        print("Invalid Option");
    }
  }
}
