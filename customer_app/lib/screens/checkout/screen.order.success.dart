import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/auth/screen.login_check.dart';
import 'package:oyil_boutique/util/constants.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderID;
  OrderSuccessScreen({this.orderID});

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/order_success.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Order Accepted",
                  style: TextStyle(fontFamily: PoppinsSemiBold, fontSize: 24, color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.orderID != null ? "Your order no. #${widget.orderID} has been placed." : "Your order has been placed successfully.",
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
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginChecker()), (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "Continue Shoping",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
