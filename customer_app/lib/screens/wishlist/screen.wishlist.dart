import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/screens/shop/single_product.dart';
import 'package:oyil_boutique/services/service.cart.dart';
import 'package:oyil_boutique/services/service.wishlist.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';

class WishListScreen extends StatefulWidget {
  final User user;
  WishListScreen({this.user});

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  WishlistDatabaseService wishlistDatabaseService = WishlistDatabaseService();
  SwipeActionController controller = SwipeActionController();

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
                  child: globalWishList.isEmpty
                      ? Center(child: Text("Wishlist is empty !", style: TextStyle(color: Colors.grey[600], fontFamily: PoppinsMedium)))
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: globalWishList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    Product p = Product(
                                        category: globalWishList[index].product.category,
                                        description: globalWishList[index].product.description,
                                        details: globalWishList[index].product.details,
                                        productId: globalWishList[index].product.productId,
                                        productname: globalWishList[index].product.productname,
                                        producttype: globalWishList[index].product.producttype,
                                        subCategory: globalWishList[index].product.subCategory,
                                        variant: Variant(
                                            color: globalWishList[index].product.variant.color,
                                            imageUrls: globalWishList[index].product.variant.imageUrls,
                                            off: globalWishList[index].product.variant.off,
                                            price: globalWishList[index].product.variant.price,
                                            productId: globalWishList[index].product.variant.productId,
                                            qty: globalWishList[index].product.variant.qty,
                                            sellingprice: globalWishList[index].product.variant.sellingprice,
                                            size: globalWishList[index].product.variant.size,
                                            variantId: globalWishList[index].product.variant.variantId,
                                            colorname: globalWishList[index].product.variant.colorname));
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProductScreen(product: p)));
                                  },
                                  child: wishListItemWidget(index));
                            },
                          ),
                        ),
                ),
              ),
              appBar(title: "Wishlist", context: context, showBackArrow: true, showWishlistIcon: false, showSearchIcon: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget wishListItemWidget(int index) {
    return SwipeActionCell(
      controller: controller,
      index: index,
      key: ValueKey(globalWishList[index]),
      performsFirstActionWithFullSwipe: true,
      trailingActions: [
        SwipeAction(
            icon: Icon(OMIcons.delete, color: Colors.white),
            color: Color(0xffF84877),
            onTap: (handler) async {
              await handler(true);
              await wishlistDatabaseService.removeProductFromWishlist(this.widget.user.uid, globalWishList[index].wishlistid, index);
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
                    image: NetworkImage(globalWishList[index].product.variant.imageUrls.first),
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
                        globalWishList[index].product.productname,
                        style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsSemiBold),
                      ),
                      Text(globalWishList[index].product.producttype, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                      Text(
                        "\u20B9 ${globalWishList[index].product.variant.sellingprice}",
                        style: TextStyle(fontSize: 14, color: Color(0xffF84877)),
                      ),
                      Text(
                        "Size ${globalWishList[index].product.variant.size} | Color: ${globalWishList[index].product.variant.colorname}",
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
                              Product p = globalWishList[index].product;
                              bool res = await CartDatabaseService().addProductToCart(this.widget.user.uid, p);
                              if (res == null) {
                                showToast("error occured", Colors.red);
                              } else if (!res) {
                                showToast("Already added to cart", Colors.blue);
                              } else {
                                showToast("Product added to cart", Colors.green);
                              }
                            },
                            child: Text(
                              "Add to Cart",
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
}
