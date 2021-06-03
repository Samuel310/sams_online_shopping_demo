import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';
import 'package:obs_admin/services/service.shop.dart';
import 'package:obs_admin/util/constants.dart';

class VariantBottomSheet extends StatefulWidget {
  final String productid, variantid;
  final Product product;
  VariantBottomSheet({this.productid, this.variantid, this.product});
  @override
  _VariantBottomSheetState createState() => _VariantBottomSheetState();
}

class _VariantBottomSheetState extends State<VariantBottomSheet> {
  bool screenLoading = true;
  Variant variant;

  @override
  void initState() {
    loadVariant();
    super.initState();
  }

  void loadVariant() async {
    try {
      variant = await ShopDatabaseService().getVariantById(this.widget.productid, this.widget.variantid);
    } catch (e) {
      print(e);
    }
    setState(() {
      screenLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 5, offset: new Offset(0.0, 0.0))],
      ),
      height: 183,
      child: screenLoading
          ? Center(
              child: SpinKitChasingDots(color: Color(0xffF84877), size: 25.0),
            )
          : variant == null
              ? Center(
                  child: Text("Unable to load", style: TextStyle(color: Colors.grey)),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          width: 40,
                          height: 3,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        // boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 3.0, offset: new Offset(0.0, 0.0))],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          onTap: () async {
                            // if (orderList[index].orderStatus == "placed") {
                            //   await Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrdersScreen(orders: orderList[index])));
                            //   orderList.remove(orderList[index]);
                            //   setState(() {});
                            // } else {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrdersScreen(orders: orderList[index])));
                            // }
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
                                      image: NetworkImage(variant.productImageList.first.url),
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
                                          this.widget.product.productname,
                                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                                        ),
                                        Text(this.widget.product.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                                        Text(
                                          "\u20B9 ${variant.sellingprice} | qty: ${variant.qty}",
                                          style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                                        ),
                                        Text(
                                          "Size: ${variant.size} | Color: ${variant.colorname}",
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
                    ),
                    SizedBox(height: 10)
                  ],
                ),
    );
  }
}
