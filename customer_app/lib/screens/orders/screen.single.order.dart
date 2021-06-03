import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/model.main.order.dart';
import 'package:oyil_boutique/screens/shop/single_product.dart';
import 'package:oyil_boutique/util/constants.dart';

class SingleOrdersScreen extends StatelessWidget {
  final MainOrder mainOrder;
  SingleOrdersScreen({this.mainOrder});
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
                      orderListItemWidget(context),
                      SizedBox(height: 20),
                      addressListItem(),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Status".toUpperCase(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold)),
                            Text("${mainOrder.orders.paid ? "Payment Successful" : "Payment Incomplete"}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                            Text("${mainOrder.orders.paid ? "\u20B9 " + mainOrder.orders.totalPrice.toString() : ""}", style: TextStyle(fontSize: 14, color: Colors.green)),
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
                                "Order ID: ${mainOrder.orders.orderId}",
                                style: TextStyle(fontSize: 14, color: Color(0xff929292), fontFamily: PoppinsRegular),
                              ),
                              Text(
                                "Status: ${mainOrder.orders.orderStatus}",
                                style: TextStyle(fontSize: 12, color: Colors.green, fontFamily: PoppinsRegular),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      //Expanded(child: SizedBox(width: 2)),
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

  Widget orderListItemWidget(BuildContext context) {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProductScreen(product: mainOrder.product)));
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
                      image: NetworkImage(mainOrder.product.variant.imageUrls.first),
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
                          mainOrder.product.productname,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                        ),
                        Text(mainOrder.product.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                        Text(
                          "\u20B9 ${mainOrder.orders.totalPrice} | qty: ${mainOrder.orders.qty}",
                          style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                        ),
                        Text(
                          "Size: ${mainOrder.product.variant.size} | Color: ${mainOrder.product.variant.colorname}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                        Text(
                          "Placed on: ${DateFormat.yMd().add_jm().format(mainOrder.orders.placedDate.toDate())}",
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
          Text("${mainOrder.orders.address.fullname} - ${mainOrder.orders.address.phone}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(mainOrder.orders.address.address, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(mainOrder.orders.address.city, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text("${mainOrder.orders.address.state} - ${mainOrder.orders.address.pincode}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(mainOrder.orders.address.country, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        ],
      ),
    );
  }
}
