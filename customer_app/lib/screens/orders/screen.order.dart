import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/model.main.order.dart';
import 'package:oyil_boutique/screens/orders/screen.single.order.dart';
import 'package:oyil_boutique/services/service.manage.orders.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';

class OrdersScreen extends StatefulWidget {
  final User user;
  OrdersScreen({this.user});
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ManageOrdersService ordersService = ManageOrdersService();
  List<MainOrder> orderList = [];
  bool loadingOrders = true;
  //ScrollController gridScrollController = ScrollController();
  ScrollController controller;
  bool gettingMoreOrders = true;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    loadOrder();
    // gridScrollController.addListener(() {
    //   double maxScroll = gridScrollController.position.maxScrollExtent;
    //   print("Scroll " + maxScroll.toString());
    //   // double currentScroll = gridScrollController.position.pixels;
    //   // double delta = MediaQuery.of(context).size.height * 0.25;
    //   // if (maxScroll - currentScroll <= delta) {
    //   //   loadMore();
    //   // }

    //   print("Scroll - Scroling");
    //   if (gridScrollController.position.atEdge) {
    //     if (gridScrollController.position.pixels != 0) {
    //       loadMore();
    //     }
    //   }

    //   // if (gridScrollController.position.extentAfter < 500) {
    //   //   loadMore();
    //   // }
    // });
  }

  @override
  void dispose() {
    //gridScrollController.dispose();
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print("Scroll - Scroling");
    if (controller.position.atEdge) {
      if (controller.position.pixels != 0) {
        loadMore();
      }
    }
  }

  Future loadOrder({bool byRefreshing = false}) async {
    dynamic res;
    setState(() {
      loadingOrders = true;
    });
    try {
      res = (byRefreshing) ? await ordersService.refresh(this.widget.user.uid) : await ordersService.getOrderList(this.widget.user.uid);
      orderList = res;
    } catch (e) {
      print(e);
      showToast(res, Colors.red);
    }
    setState(() {
      loadingOrders = false;
    });
    loadMore();
  }

  void loadMore() async {
    print("Loading more..");
    dynamic res;
    try {
      res = await ordersService.getMoreOrderList(this.widget.user.uid);
      if (res != null) {
        List<MainOrder> list = res;
        list.forEach((element) {
          orderList.add(element);
        });
        setState(() {});
      } else {
        orderList = [];
      }
    } catch (e) {
      print(e);
      print("scroll - Error");
      setState(() {
        gettingMoreOrders = false;
      });
      print(res);
    }
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
                padding: const EdgeInsets.only(top: 56),
                child: Container(
                  child: loadingOrders == true
                      ? Center(child: SpinKitChasingDots(color: Color(0xffF84877), size: 40.0))
                      : orderList == null || orderList.length == 0
                          ? Center(child: Text("no orders placed yet"))
                          : RefreshIndicator(
                              color: Color(0xffF84877),
                              onRefresh: () {
                                setState(() {
                                  orderList.clear();
                                  gettingMoreOrders = true;
                                });
                                return loadOrder(byRefreshing: true);
                              },
                              child: ListView.separated(
                                //shrinkWrap: true,
                                //controller: gridScrollController,
                                controller: controller,
                                itemCount: orderList.length + 1,
                                itemBuilder: (context, index) {
                                  print("${orderList.length} and $index");
                                  if (index == orderList.length) {
                                    print(gettingMoreOrders);
                                    return Visibility(
                                      visible: gettingMoreOrders,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: SpinKitChasingDots(color: Color(0xffF84877), size: 20.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //child: Text("Loading..."),
                                    );
                                  } else {
                                    return orderListItemWidget(index);
                                  }
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Divider(
                                      color: Color(0xffD3D3D3),
                                    ),
                                  );
                                },
                              ),
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

  Widget orderListItemWidget(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 3.0, offset: new Offset(0.0, 1.0))],
        //border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrdersScreen(mainOrder: orderList[index])));
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
                      image: NetworkImage(orderList[index].product.variant.imageUrls.first),
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
                          orderList[index].product.productname,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                        ),
                        Text(orderList[index].product.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                        Text(
                          "\u20B9 ${orderList[index].orders.totalPrice} | qty: ${orderList[index].orders.qty}",
                          style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                        ),
                        Text(
                          "Size: ${orderList[index].product.variant.size} | Color: ${orderList[index].product.variant.colorname}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                        Text(
                          "Placed on: ${DateFormat.yMd().add_jm().format(orderList[index].orders.placedDate.toDate())}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                        Text(
                          "Status: ${orderList[index].orders.orderStatus}",
                          style: TextStyle(fontSize: 10, color: Colors.green, fontFamily: PoppinsRegular),
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
}
