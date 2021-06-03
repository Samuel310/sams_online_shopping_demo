import 'package:flutter/material.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/orders/screen.order.dart';
import 'package:obs_admin/util/constants.dart';

class OrderSliderScreen extends StatefulWidget {
  @override
  _OrderSliderScreenState createState() => _OrderSliderScreenState();
}

class _OrderSliderScreenState extends State<OrderSliderScreen> {
  int currentIndex;
  PageController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 56),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [topTabItem(0, "Placed"), topTabItem(1, "Shipped")],
                      ),
                      Expanded(
                        child: PageView(
                          controller: controller,
                          onPageChanged: (value) {
                            setState(() {
                              currentIndex = value;
                            });
                          },
                          children: <Widget>[
                            OrdersScreen(orderStatus: "placed"),
                            OrdersScreen(orderStatus: "shipped"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              appBar(title: "Orders", showBackArrow: true, context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget topTabItem(int index, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            controller.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.ease);
          });
        },
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: (currentIndex == index) ? Colors.black : Color(0xff7F7F7F), fontFamily: PoppinsRegular, fontSize: 15),
            ),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(shape: BoxShape.circle, color: (currentIndex == index) ? Color(0xffF84877) : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
