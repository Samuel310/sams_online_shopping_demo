import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/screens/shop/local_widgets/product_tile.dart';
import 'package:oyil_boutique/screens/shop/single_product.dart';
import 'package:oyil_boutique/services/service.shop.dart';
import 'package:oyil_boutique/util/common.dart';

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
    // gridScrollController.addListener(() {
    //   double maxScroll = gridScrollController.position.maxScrollExtent;
    //   double currentScroll = gridScrollController.position.pixels;
    //   double delta = MediaQuery.of(context).size.height * 0.25;
    //   if (maxScroll - currentScroll <= delta) {
    //     loadMore();
    //   }
    // });
  }

  @override
  void dispose() {
    //gridScrollController.dispose();
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
      showToast("Error occured", Colors.red);
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
        productList = res;
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
    double width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: loadingProducts == true
          ? Center(
              child: SpinKitChasingDots(
                color: Color(0xffF84877),
                size: 40.0,
              ),
            )
          : productList == null || productList.length == 0
              ? Center(
                  child: Text("no products found"),
                )
              : RefreshIndicator(
                  color: Color(0xffF84877),
                  onRefresh: () {
                    setState(() {
                      productList.clear();
                      gettingMoreProducts = true;
                    });
                    return loadProduct(byRefreshing: true);
                  },
                  child: GridView.builder(
                    shrinkWrap: true,
                    controller: gridScrollController,
                    itemCount: productList.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (width / 300)),
                    itemBuilder: (context, index) {
                      if (index == productList.length) {
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
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProductScreen(product: productList[index]), settings: RouteSettings(name: 'SingleProductScreen')));
                            },
                            child: ProductTile(
                              product: productList[index],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
    );
  }
}
