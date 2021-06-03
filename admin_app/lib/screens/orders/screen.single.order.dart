import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obs_admin/models/model.order.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/products/screen.manage.product.dart';
import 'package:obs_admin/services/service.fcm.dart';
import 'package:obs_admin/services/service.manage.orders.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:obs_admin/util/progress.screen.dart';

class SingleOrdersScreen extends StatefulWidget {
  final Order orders;

  SingleOrdersScreen({this.orders});

  @override
  _SingleOrdersScreenState createState() => _SingleOrdersScreenState();
}

class _SingleOrdersScreenState extends State<SingleOrdersScreen> {
  ProgressScreen ps = ProgressScreen();
  bool showButton;
  String shipped;
  @override
  void initState() {
    showButton = this.widget.orders.orderStatus == "placed";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 56, left: 10, right: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      orderListItemWidget(),
                      SizedBox(height: 20),
                      addressListItem(),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Status".toUpperCase(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold)),
                            Text("${widget.orders.paid ? "Payment Successful" : "Payment Incomplete"}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                            Text("${widget.orders.paid ? "\u20B9 " + widget.orders.totalPrice.toString() : ""}", style: TextStyle(fontSize: 14, color: Colors.green)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Visibility(visible: showButton, child: Expanded(child: SizedBox(width: 2))),
                      Visibility(
                        visible: showButton,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xffF84877),
                              ),
                              onPressed: () async {
                                showProgressDialog(context, ps);
                                String res = await ManageOrdersService().updateStatusToShipped(widget.orders.orderId);
                                dismissProgressDialog(context, ps);
                                if (res != null) {
                                  showToast(res, Colors.red);
                                } else {
                                  await sendNotification(
                                      this.widget.orders.userId, "Oyil", "Your order of ${this.widget.orders.productData.productname} ${this.widget.orders.productData.producttype} is shipped");
                                  setState(() {
                                    shipped = "shipped";
                                    showButton = !showButton;
                                  });
                                }
                              },
                              child: Text("Ship Order", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox(width: 2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Order ID: ${widget.orders.orderId}",
                                style: TextStyle(fontSize: 14, color: Color(0xff929292), fontFamily: PoppinsRegular),
                              ),
                              Text(
                                "Status: ${shipped == null ? widget.orders.orderStatus : shipped}",
                                style: TextStyle(fontSize: 12, color: Colors.green, fontFamily: PoppinsRegular),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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

  Widget orderListItemWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 10.0, offset: new Offset(0.0, 3.0))],
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageProductScreen(product: this.widget.orders.productData)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(widget.orders.variantData.productImageList.first.url),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orders.productData.productname,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                        ),
                        Text(widget.orders.productData.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                        Text(
                          "\u20B9 ${widget.orders.totalPrice} | qty: ${widget.orders.qty}",
                          style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                        ),
                        Text(
                          "Size: ${widget.orders.variantData.size} | Color: ${widget.orders.variantData.colorname}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                        Text(
                          "Placed on: ${DateFormat.yMd().add_jm().format(widget.orders.placedDate.toDate())}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addressListItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ADDRESS", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold)),
          Text("${widget.orders.fullname} - ${widget.orders.phone}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text("${widget.orders.ahEmail}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(widget.orders.address, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(widget.orders.city, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text("${widget.orders.state} - ${widget.orders..pincode}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(widget.orders.country, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        ],
      ),
    );
  }
}
