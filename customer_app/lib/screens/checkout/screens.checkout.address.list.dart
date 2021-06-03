import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/modal.checkout.dart';
import 'package:oyil_boutique/models/models.address.dart';
import 'package:oyil_boutique/screens/checkout/screens.add.address.dart';
import 'package:oyil_boutique/screens/checkout/screens.summary.dart';
import 'package:oyil_boutique/util/constants.dart';

class CheckoutAddressList extends StatelessWidget {
  final CheckoutModel checkoutProduct;
  final List<CheckoutModel> checkoutProductList;
  final User user;
  final List<ShippingAddress> shippingAddressList;
  CheckoutAddressList({this.checkoutProduct, this.user, this.shippingAddressList, this.checkoutProductList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Select Shipping Address",
                          style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: PoppinsSemiBold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: shippingAddressList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  child: InkWell(
                                      onTap: () {
                                        if (checkoutProductList != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SummaryScreen(
                                                  shippingAddress: shippingAddressList[index],
                                                  user: user,
                                                  checkoutProductList: checkoutProductList,
                                                ),
                                              ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SummaryScreen(
                                                  checkoutProduct: checkoutProduct,
                                                  shippingAddress: shippingAddressList[index],
                                                  user: user,
                                                ),
                                              ));
                                        }
                                      },
                                      child: addressListItem(shippingAddressList[index])),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: Color(0xffF84877),
                                ),
                                onPressed: () {
                                  if (checkoutProductList != null) {
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddAddress(
                                            checkoutProduct: checkoutProduct,
                                            user: user,
                                          ),
                                        ));
                                  }
                                },
                                child: Text(
                                  "Add New Address",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(height: 15)
                      ],
                    ),
                  ),
                ),
              ),
              appBar(title: "Address", showBackArrow: true, context: context)
            ],
          ),
        ),
      ),
    );
  }

  Widget addressListItem(ShippingAddress address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${address.fullname} - ${address.phone}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text(address.address, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text(address.city, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text("${address.state} - ${address.pincode}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text(address.country, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
      ],
    );
  }
}
