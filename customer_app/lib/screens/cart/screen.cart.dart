import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/models/modal.checkout.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/screens/checkout/screens.checkout.wrapper.dart';
import 'package:oyil_boutique/screens/shop/single_product.dart';
import 'package:oyil_boutique/services/service.cart.dart';
import 'package:oyil_boutique/services/service.wishlist.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';

class CartScreen extends StatefulWidget {
  final User user;
  CartScreen({this.user});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartDatabaseService cartDatabaseService = CartDatabaseService();
  int totalPrice = 0;
  SwipeActionController controller = SwipeActionController();

  @override
  void initState() {
    super.initState();
    globalCartList.forEach((element) {
      totalPrice += element.product.variant.sellingprice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: globalCartList.isEmpty
          ? Center(child: Text("Cart is empty !", style: TextStyle(color: Colors.grey[600], fontFamily: PoppinsMedium)))
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: globalCartList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Product p = Product(
                                  category: globalCartList[index].product.category,
                                  description: globalCartList[index].product.description,
                                  details: globalCartList[index].product.details,
                                  productId: globalCartList[index].product.productId,
                                  productname: globalCartList[index].product.productname,
                                  producttype: globalCartList[index].product.producttype,
                                  subCategory: globalCartList[index].product.subCategory,
                                  variant: Variant(
                                      color: globalCartList[index].product.variant.color,
                                      imageUrls: globalCartList[index].product.variant.imageUrls,
                                      off: globalCartList[index].product.variant.off,
                                      price: globalCartList[index].product.variant.price,
                                      productId: globalCartList[index].product.variant.productId,
                                      qty: globalCartList[index].product.variant.qty,
                                      sellingprice: globalCartList[index].product.variant.sellingprice,
                                      size: globalCartList[index].product.variant.size,
                                      variantId: globalCartList[index].product.variant.variantId,
                                      colorname: globalCartList[index].product.variant.colorname));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProductScreen(product: p)));
                            },
                            child: cartItemWidget(index));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Total", style: TextStyle(fontSize: 12, fontFamily: PoppinsRegular, color: Color(0xff929292))),
                        Text('\u20B9 $totalPrice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xffF84877)))
                      ])),
                      SizedBox(
                        height: 45,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Color(0xffF84877),
                          ),
                          onPressed: () {
                            onCkeckoutBtnClicked();
                          },
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget cartItemWidget(int index) {
    return SwipeActionCell(
      controller: controller,
      index: index,
      key: ValueKey(globalCartList[index]),
      performsFirstActionWithFullSwipe: true,
      trailingActions: [
        SwipeAction(
            icon: Icon(OMIcons.delete, color: Colors.white),
            color: Color(0xffF84877),
            onTap: (handler) async {
              await handler(true);
              totalPrice -= globalCartList[index].product.variant.sellingprice;
              await cartDatabaseService.removeProductFromCart(this.widget.user.uid, globalCartList[index].cartid, index);
              setState(() {});
            }),
      ],
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(globalCartList[index].product.variant.imageUrls.first),
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
                        globalCartList[index].product.productname,
                        style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                      ),
                      Text(globalCartList[index].product.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                      Text(
                        "\u20B9 ${globalCartList[index].product.variant.sellingprice}",
                        style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                      ),
                      Text(
                        "Size ${globalCartList[index].product.variant.size} | Color: ${globalCartList[index].product.variant.colorname}",
                        style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                      ),
                      SizedBox(
                        height: 30,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Color(0xff515c6f),
                            ),
                            onPressed: () async {
                              Product p = globalCartList[index].product;
                              bool res = await WishlistDatabaseService().addProductToWishlist(this.widget.user.uid, p);
                              if (res != null) {
                                if (res) {
                                  showToast("Product added to wishlist", Colors.green);
                                } else {
                                  showToast("Already Exists", Colors.blue);
                                }
                              } else {
                                showToast("Unable to add, try again later", Colors.red);
                              }
                            },
                            child: Text(
                              "Add to wishlist",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  void onCkeckoutBtnClicked() {
    List<CheckoutModel> cmList = [];
    globalCartList.forEach((element) {
      cmList.add(CheckoutModel(buyingQty: 1, product: element.product));
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckoutWrapperScreen(
                  checkoutProductList: cmList,
                )));
  }
}
