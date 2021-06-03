import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:obs_admin/models/model.liked.products.dart';
import 'package:obs_admin/screens/analytics/screen.variant.bottomsheet.dart';
import 'package:obs_admin/services/service.shop.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';

class AnalyticsScreen extends StatefulWidget {
  final String screenName;
  AnalyticsScreen({this.screenName});
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final ShopDatabaseService shopDB = ShopDatabaseService();
  List<LikedProduct> productList = [];
  bool loadingProducts = true;
  GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future loadProduct() async {
    dynamic res;
    setState(() {
      loadingProducts = true;
    });
    try {
      res = await shopDB.getTopLikedProducts(this.widget.screenName);
      productList = res;
    } catch (e) {
      print(e);
      showToast(res.toString(), Colors.red);
    }
    setState(() {
      loadingProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaffold,
      body: loadingProducts == true
          ? Center(child: SpinKitChasingDots(color: Color(0xffF84877), size: 40.0))
          : productList == null || productList.length == 0
              ? Center(child: Text("no products found"))
              : RefreshIndicator(
                  color: Color(0xffF84877),
                  onRefresh: () {
                    setState(() {
                      productList.clear();
                    });
                    return loadProduct();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: productTile(index),
                      );
                    },
                  ),
                ),
    );
  }

  Widget productTile(int index) {
    return Container(
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
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ManageProductScreen(product: productList[index])));
            _keyScaffold.currentState
                .showBottomSheet((context) => VariantBottomSheet(product: productList[index].product, productid: productList[index].product.productId, variantid: productList[index].variantid));
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Count", style: TextStyle(fontSize: 10, fontFamily: PoppinsRegular, color: Colors.grey)),
                            Text(productList[index].likes.toString(), style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular)),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Product Name", style: TextStyle(fontSize: 10, fontFamily: PoppinsRegular, color: Colors.grey)),
                                Text(productList[index].product.productname, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xffF84877))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(width: 1, color: Colors.grey)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Product Type", style: TextStyle(fontSize: 10, fontFamily: PoppinsRegular, color: Colors.grey)),
                          Text(productList[index].product.producttype, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xffF84877))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget variantBottomSheet() {

  //   return Container(
  //     height: 300,
  //     color: Colors.grey,
  //   );
  // }
}
