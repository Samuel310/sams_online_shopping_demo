import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:obs_admin/models/model.order.dart';
import 'package:obs_admin/screens/orders/screen.single.order.dart';
import 'package:obs_admin/services/service.manage.orders.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';

class OrdersScreen extends StatefulWidget {
  final String orderStatus;
  OrdersScreen({this.orderStatus});
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ManageOrdersService ordersService = ManageOrdersService();
  List<Order> orderList = [];
  bool loadingOrders = true;
  ScrollController gridScrollController = ScrollController();
  bool gettingMoreOrders = true;

  @override
  void initState() {
    super.initState();
    gridScrollController = new ScrollController()..addListener(_scrollListener);
    loadOrder();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    gridScrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print("Scroll - Scroling");
    if (gridScrollController.position.atEdge) {
      if (gridScrollController.position.pixels != 0) {
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
      res = (byRefreshing) ? await ordersService.refresh(this.widget.orderStatus) : await ordersService.getOrderList(this.widget.orderStatus);
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
      res = await ordersService.getMoreOrderList(this.widget.orderStatus);
      if (res != null) {
        List<Order> list = res;
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
      body: Container(
        color: Colors.white,
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: gridScrollController,
                      itemCount: orderList.length + 1,
                      itemBuilder: (context, index) {
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: orderTile(index),
                          );
                        }
                      },
                    ),
                  ),
      ),
    );
  }

  Widget orderTile(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 3.0, offset: new Offset(0.0, 0.0))],
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          onTap: () async {
            if (orderList[index].orderStatus == "placed") {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrdersScreen(orders: orderList[index])));
              orderList.remove(orderList[index]);
              setState(() {});
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrdersScreen(orders: orderList[index])));
            }
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
                      image: NetworkImage(orderList[index].variantData.productImageList.first.url),
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
                          orderList[index].productData.productname,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                        ),
                        Text(orderList[index].productData.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                        Text(
                          "\u20B9 ${orderList[index].totalPrice} | qty: ${orderList[index].qty}",
                          style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                        ),
                        Text(
                          "Size: ${orderList[index].variantData.size} | Color: ${orderList[index].variantData.colorname}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                        Text(
                          "Placed on: ${DateFormat.yMd().add_jm().format(orderList[index].placedDate.toDate())}",
                          style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                        ),
                        Text(
                          "Status: ${orderList[index].orderStatus}",
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
