import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/screens/products/screen.manage.product.dart';
import 'package:obs_admin/services/service.shop.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';

class ProductSubCategoryScreen extends StatefulWidget {
  final String subCategory;
  final String category;
  ProductSubCategoryScreen({this.subCategory, this.category});
  @override
  _ProductSubCategoryScreenState createState() => _ProductSubCategoryScreenState();
}

class _ProductSubCategoryScreenState extends State<ProductSubCategoryScreen> {
  final ShopDatabaseService shopDB = ShopDatabaseService();
  List<Product> productList = [];
  bool loadingProducts = true;
  ScrollController gridScrollController = ScrollController();
  bool gettingMoreProducts = true;

  @override
  void initState() {
    super.initState();
    gridScrollController = new ScrollController()..addListener(_scrollListener);
    loadProduct();
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

  Future loadProduct({bool byRefreshing = false}) async {
    dynamic res;
    setState(() {
      loadingProducts = true;
    });
    try {
      if (this.widget.subCategory != null) {
        res = (byRefreshing)
            ? await shopDB.refresh(category: this.widget.category, subcategory: this.widget.subCategory)
            : await shopDB.getProductList(category: this.widget.category, subcategory: this.widget.subCategory);
      } else {
        res = (byRefreshing) ? await shopDB.refresh(category: this.widget.category) : await shopDB.getProductList(category: this.widget.category);
      }
      productList = res;
    } catch (e) {
      print(e);
      showToast(res, Colors.red);
    }
    setState(() {
      loadingProducts = false;
    });
    loadMore();
  }

  void loadMore() async {
    dynamic res;
    try {
      if (this.widget.subCategory != null) {
        res = await shopDB.getMoreProductList(category: this.widget.category, subcategory: this.widget.subCategory);
      } else {
        res = await shopDB.getMoreProductList(category: this.widget.category);
      }
      if (res != null) {
        List<Product> list = res;
        list.forEach((element) {
          productList.add(element);
        });
        setState(() {});
      } else {
        productList = [];
      }
    } catch (e) {
      print(e);
      print("scroll - Error");
      setState(() {
        gettingMoreProducts = false;
      });
      print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingProducts == true
          ? Center(child: SpinKitChasingDots(color: Color(0xffF84877), size: 40.0))
          : productList == null || productList.length == 0
              ? Center(child: Text("no products found"))
              : RefreshIndicator(
                  color: Color(0xffF84877),
                  onRefresh: () {
                    setState(() {
                      productList.clear();
                      gettingMoreProducts = true;
                    });
                    return loadProduct(byRefreshing: true);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: gridScrollController,
                    itemCount: productList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == productList.length) {
                        print(gettingMoreProducts);
                        return Visibility(
                          visible: gettingMoreProducts,
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
                          child: productTile(index),
                        );
                      }
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageProductScreen(product: productList[index])));
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
                            Text("S.no", style: TextStyle(fontSize: 10, fontFamily: PoppinsRegular, color: Colors.grey)),
                            Text("${index + 1}", style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular)),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Product Name", style: TextStyle(fontSize: 10, fontFamily: PoppinsRegular, color: Colors.grey)),
                                Text(productList[index].productname, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xffF84877))),
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
                          Text(productList[index].producttype, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xffF84877))),
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
}
