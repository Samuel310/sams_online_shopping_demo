import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/modaal.order.confirmation.dart';
import 'package:oyil_boutique/models/modal.checkout.dart';
import 'package:oyil_boutique/models/modals.orders.dart';
import 'package:oyil_boutique/models/models.address.dart';
import 'package:oyil_boutique/screens/auth/screen.login_check.dart';
import 'package:oyil_boutique/screens/checkout/screen.order.success.dart';
import 'package:oyil_boutique/services/service.cart.dart';
import 'package:oyil_boutique/services/service.checkout.dart';
import 'package:oyil_boutique/services/service.fcm.dart';
import 'package:oyil_boutique/services/service.shop.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SummaryScreen extends StatefulWidget {
  final ShippingAddress shippingAddress;
  final CheckoutModel checkoutProduct;
  final List<CheckoutModel> checkoutProductList;
  final User user;
  SummaryScreen({this.shippingAddress, this.checkoutProduct, this.user, this.checkoutProductList});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final CheckOutDatabaseService checkOutDatabaseService = CheckOutDatabaseService();
  final ShopDatabaseService shopDatabaseService = ShopDatabaseService();
  final Razorpay _razorpay = Razorpay();
  int buyingQty;

  int totalQty;
  Orders finalOrder;
  List<OrderConfirmationModel> ocList = [];

  @override
  void initState() {
    super.initState();
    if (this.widget.checkoutProduct != null) {
      buyingQty = this.widget.checkoutProduct.buyingQty;
    }
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (ocList.isNotEmpty) {
      try {
        for (OrderConfirmationModel ocm in ocList) {
          await checkOutDatabaseService.finalizeOrder(ocm.order.orderId);
          await shopDatabaseService.updateProductQty(ocm.previousAvailableQty - ocm.order.qty, ocm.order.productId, ocm.order.variantId);
        }
        await CartDatabaseService().deleteCart(this.widget.user.uid);
      } catch (e) {
        print("Error xxxxxxxx _handlePaymentSuccess");
        print(e);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccessScreen()));
    } else {
      bool x = await checkOutDatabaseService.finalizeOrder(finalOrder.orderId);
      bool y = await shopDatabaseService.updateProductQty(totalQty - buyingQty, this.widget.checkoutProduct.product.productId, this.widget.checkoutProduct.product.variant.variantId);
      if (x && y) {
        sendNotification("Sam\'s Store", "New order has been placed");
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderSuccessScreen(
                      orderID: finalOrder.orderId,
                    )));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginChecker()), (Route<dynamic> route) => false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  void openCheckout() async {
    var options = {
      'key': RAZORPAY_KEY,
      'amount': finalOrder.totalPrice * 100,
      'name': 'Sam\'s Store',
      'description': 'Order Id: ${finalOrder.orderId} | ${this.widget.checkoutProduct.product.productname}, ${this.widget.checkoutProduct.product.producttype}',
      'prefill': {'contact': this.widget.shippingAddress.phone, 'email': this.widget.user.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void openMultipleProductCheckout(int orderLength, int totalPrice) {
    var options = {
      'key': RAZORPAY_KEY,
      'amount': totalPrice * 100,
      'name': 'Sam\'s Store',
      'description': '$orderLength Products',
      'prefill': {'contact': this.widget.shippingAddress.phone, 'email': this.widget.user.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void onPayMultipleBtnClicked() async {
    List<OrderConfirmationModel> confirmationlist = [];
    int totalPrice = 0;
    for (CheckoutModel cm in this.widget.checkoutProductList) {
      int availableQty = await shopDatabaseService.getProductQty(cm.product.productId, cm.product.variant.variantId);
      if (availableQty != null) {
        if (cm.buyingQty <= availableQty) {
          Orders order = Orders(
            address: this.widget.shippingAddress,
            orderStatus: 'placed',
            paid: false,
            placedDate: Timestamp.fromDate(DateTime.now()),
            productId: cm.product.productId,
            qty: cm.buyingQty,
            totalPrice: cm.product.variant.sellingprice * cm.buyingQty,
            userId: this.widget.user.uid,
            variantId: cm.product.variant.variantId,
            ahEmail: this.widget.user.email,
          );
          Orders updatedOrder = await checkOutDatabaseService.placeOrder(order);
          if (updatedOrder != null) {
            totalPrice += updatedOrder.totalPrice;
            confirmationlist.add(OrderConfirmationModel(order: updatedOrder, previousAvailableQty: availableQty));
          } else {
            showToast("Unable to place order", Colors.red);
          }
        } else {
          showToast("Some products are not in stock", Colors.blue);
          break;
        }
      } else {
        showToast("Unable to check availability for some products", Colors.red);
        break;
      }
    }
    if (this.widget.checkoutProductList.length == confirmationlist.length) {
      setState(() {
        ocList.addAll(confirmationlist);
      });
      openMultipleProductCheckout(confirmationlist.length, totalPrice);
    } else {
      showToast("Failed to place order, please try again later", Colors.red);
    }
  }

  void onPayBtnClicked() async {
    int availableQty = await shopDatabaseService.getProductQty(this.widget.checkoutProduct.product.productId, this.widget.checkoutProduct.product.variant.variantId);
    if (availableQty != null) {
      if (buyingQty <= availableQty) {
        Orders order = Orders(
          address: this.widget.shippingAddress,
          orderStatus: 'placed',
          paid: false,
          placedDate: Timestamp.fromDate(DateTime.now()),
          productId: this.widget.checkoutProduct.product.productId,
          qty: buyingQty,
          totalPrice: this.widget.checkoutProduct.product.variant.sellingprice * buyingQty,
          userId: this.widget.user.uid,
          variantId: this.widget.checkoutProduct.product.variant.variantId,
          ahEmail: this.widget.user.email,
        );
        Orders updatedOrder = await checkOutDatabaseService.placeOrder(order);
        if (updatedOrder != null) {
          setState(() {
            totalQty = availableQty;
            finalOrder = updatedOrder;
          });
          openCheckout();
        } else {
          Fluttertoast.showToast(
              msg: "Unable to place order", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "This Product is out of stock",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Unable to check availability",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

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
                  padding: const EdgeInsets.only(top: 56, bottom: 65),
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          this.widget.checkoutProductList != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: this.widget.checkoutProductList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image: NetworkImage(this.widget.checkoutProductList[index].product.variant.imageUrls.first),
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
                                                    this.widget.checkoutProductList[index].product.productname,
                                                    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: PoppinsSemiBold),
                                                  ),
                                                  Text(this.widget.checkoutProductList[index].product.producttype, style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: PoppinsRegular)),
                                                  Text(
                                                    "\u20B9 ${this.widget.checkoutProductList[index].product.variant.sellingprice}",
                                                    style: TextStyle(fontSize: 15, color: Color(0xffF84877)),
                                                  ),
                                                  Text(
                                                    "Size ${this.widget.checkoutProductList[index].product.variant.size} | Color: ${this.widget.checkoutProductList[index].product.variant.colorname}",
                                                    style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(widget.checkoutProduct.product.variant.imageUrls.first),
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
                                                widget.checkoutProduct.product.productname,
                                                style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: PoppinsSemiBold),
                                              ),
                                              Text(widget.checkoutProduct.product.producttype, style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: PoppinsRegular)),
                                              Text(
                                                "\u20B9 ${widget.checkoutProduct.product.variant.sellingprice}",
                                                style: TextStyle(fontSize: 15, color: Color(0xffF84877)),
                                              ),
                                              Text(
                                                "Size ${widget.checkoutProduct.product.variant.size} | Color: ${widget.checkoutProduct.product.variant.colorname}",
                                                style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Shipping Address",
                              style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: PoppinsSemiBold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: addressWidget(),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  color: Color(0xffF84877),
                                  fontSize: 14,
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  )),
              appBar(title: "Summary", showBackArrow: true, context: context),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 7.5),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // borderSide: BorderSide(
                                  //   color: Color(0xffF84877),
                                  //   style: BorderStyle.solid,
                                  //   width: 1,
                                  // ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7.5),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: Color(0xffF84877),
                                ),
                                onPressed: () {
                                  if (this.widget.checkoutProductList != null) {
                                    onPayMultipleBtnClicked();
                                  } else {
                                    onPayBtnClicked();
                                  }
                                },
                                child: Text(
                                  "Pay",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addressWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.shippingAddress.fullname} - ${widget.shippingAddress.phone}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text(widget.shippingAddress.address, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text(widget.shippingAddress.city, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text("${widget.shippingAddress.state} - ${widget.shippingAddress.pincode}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        Text(widget.shippingAddress.country, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
      ],
    );
  }
}
