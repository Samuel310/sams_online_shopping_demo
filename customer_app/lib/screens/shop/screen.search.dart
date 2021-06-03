import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/screens/shop/local_widgets/product_tile.dart';
import 'package:oyil_boutique/screens/shop/single_product.dart';
import 'package:oyil_boutique/services/service.shop.dart';

class SearchScreen extends StatefulWidget {
  // final String subCategory;
  // final String category;
  // SearchScreen({this.subCategory, this.category});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Product> querySearchSet = [];
  List<Product> tempSearchList = [];
  ShopDatabaseService manageProductService = ShopDatabaseService();
  ScrollController gridScrollController = ScrollController();

  void initiateSearch(String value) async {
    if (value.length == 0) {
      setState(() {
        querySearchSet = [];
        tempSearchList = [];
      });
    } else {
      String searchKey = value.substring(0, 1).toUpperCase() + value.substring(1);
      if (querySearchSet.length == 0 && value.length == 1) {
        List<Product> list = await manageProductService.searchProduct(searchKey);
        querySearchSet.addAll(list);
      } else {
        tempSearchList = [];
        querySearchSet.forEach(
          (product) {
            if (product.productname.startsWith(searchKey)) {
              setState(() {
                tempSearchList.add(product);
              });
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: GridView.builder(
                      shrinkWrap: true,
                      controller: gridScrollController,
                      itemCount: tempSearchList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (width / 300)),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleProductScreen(
                                              product: tempSearchList[index],
                                            ),
                                        settings: RouteSettings(
                                          name: 'SingleProductScreen',
                                        )));
                              },
                              child: ProductTile(
                                product: tempSearchList[index],
                              )),
                        );
                      },
                    ),
                  ),
                ),
              ),
              appBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: RawMaterialButton(
                shape: CircleBorder(),
                child: Icon(
                  OMIcons.arrowBack,
                  color: Color(0xff515C6F),
                ),
                onPressed: () {
                  if (context != null) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  onChanged: (value) => initiateSearch(value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                    contentPadding: EdgeInsets.only(top: 3),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: RawMaterialButton(
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
                child: Icon(
                  OMIcons.search,
                  color: Color(0xff515C6F),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
