import 'package:flutter/material.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/screens/products/screen.manage.product.dart';
import 'package:obs_admin/services/service.manage.product.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

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
  ManageProductService manageProductService = ManageProductService();

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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tempSearchList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: productTile(index),
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

  Widget productTile(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 10.0, offset: new Offset(0.0, 3.0))],
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageProductScreen(product: tempSearchList[index])));
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
                                Text(tempSearchList[index].productname, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xffF84877))),
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
                          Text(tempSearchList[index].producttype, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xffF84877))),
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
