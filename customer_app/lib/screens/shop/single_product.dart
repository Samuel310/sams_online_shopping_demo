import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/modal.checkout.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/screens/checkout/screens.checkout.wrapper.dart';
import 'package:oyil_boutique/services/service.cart.dart';
import 'package:oyil_boutique/services/service.shop.dart';
import 'package:oyil_boutique/services/service.wishlist.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_color/smart_color.dart';

class SingleProductScreen extends StatefulWidget {
  final Product product;
  SingleProductScreen({this.product});
  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  Variant variant;
  List<Variant> variantList = [];
  List<String> colorList = [];
  List<String> availableSize = [];
  bool loadingVariants = true;
  ShopDatabaseService shopDatabaseService = ShopDatabaseService();
  int _current = 0;
  WishlistDatabaseService wishlistDatabaseService = WishlistDatabaseService();

  int buyingQty = 1;

  @override
  void initState() {
    variant = this.widget.product.variant;
    super.initState();
    initVariantList();
  }

  void initVariantList() async {
    setState(() {
      loadingVariants = true;
    });
    variantList = await shopDatabaseService.getAllVariants(this.widget.product.productId);
    variantList.forEach((v) {
      if (!colorList.contains(v.color)) {
        colorList.add(v.color);
      }
      if (v.color == variant.color) {
        availableSize.add(v.size);
      }
    });
    setState(() {
      loadingVariants = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    double h = MediaQuery.of(context).size.height;
    int wishlistIndex;
    String wishlistid;
    bool isLiked = false;
    globalWishList.forEach((element) {
      if (element.product.productId == this.widget.product.productId) {
        isLiked = true;
        wishlistid = element.wishlistid;
        wishlistIndex = globalWishList.indexOf(element);
      }
    });
    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: (loadingVariants)
              ? Center(
                  child: SpinKitChasingDots(
                    color: Color(0xffF84877),
                    size: 40.0,
                  ),
                )
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 56),
                      child: Container(
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: h,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                          items: variant.imageUrls
                              .map((url) => Container(
                                    child: Center(child: Image(image: NetworkImage(url), fit: BoxFit.cover, height: h)),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    appBar(title: "Womens", showBackArrow: true, context: context),
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: DraggableScrollableSheet(
                        builder: (context, scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 8,
                                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        this.widget.product.productname,
                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: PoppinsSemiBold),
                                                      )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        this.widget.product.description,
                                                        style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsRegular),
                                                      )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\u20B9 ${variant.sellingprice}",
                                                        style: TextStyle(fontSize: 15, color: Colors.black),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(
                                                          "\u20B9 ${variant.price}",
                                                          style: TextStyle(fontSize: 12, color: Color(0xff929292), decoration: TextDecoration.lineThrough),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(isLiked ? OMIcons.favorite : OMIcons.favoriteBorder, color: isLiked ? Color(0xffF84877) : Colors.black),
                                                      onPressed: () async {
                                                        if (user != null) {
                                                          if (isLiked) {
                                                            await wishlistDatabaseService.removeProductFromWishlist(user.uid, wishlistid, wishlistIndex);
                                                            setState(() {});
                                                          } else {
                                                            Product p = this.widget.product;
                                                            p.variant = this.variant;
                                                            await wishlistDatabaseService.addProductToWishlist(user.uid, p);
                                                            setState(() {});
                                                          }
                                                        } else {
                                                          showToast("Please login to continue", Colors.blue);
                                                        }
                                                      },
                                                    ),
                                                    // IconButton(
                                                    //   icon: Icon(OMIcons.share),
                                                    //   onPressed: () {},
                                                    // )
                                                  ],
                                                ),
                                                Text(
                                                  "${double.parse((variant.off).toStringAsFixed(2))}% OFF",
                                                  style: TextStyle(fontSize: 12, color: Color(0xffF84877), fontFamily: PoppinsRegular, decoration: TextDecoration.underline),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 20,
                                        color: Color(0xffF9F9F9),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          children: [
                                            Text("Select Color", style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsRegular)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Container(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: colorList.length,
                                            itemBuilder: (context, index) {
                                              if (colorList[index] == variant.color) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: selectedColorButton(colorList[index]),
                                                );
                                              } else {
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: InkWell(
                                                      onTap: () {
                                                        String selectedColor = colorList[index];
                                                        List<String> sizeList = [];
                                                        Variant tempVariant;
                                                        variantList.forEach((v) {
                                                          if (v.color == selectedColor) {
                                                            sizeList.add(v.size);
                                                            if (sizeList.length == 1) {
                                                              tempVariant = v;
                                                            }
                                                          }
                                                        });
                                                        if (tempVariant != null) {
                                                          setState(() {
                                                            variant = tempVariant;
                                                            availableSize = sizeList;
                                                          });
                                                        }
                                                      },
                                                      child: colorButton(colorList[index])),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Select Size", style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsRegular)),
                                            Text(
                                              "Size Guide",
                                              style: TextStyle(fontSize: 12, color: Color(0xffF84877), fontFamily: PoppinsRegular, decoration: TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Container(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: availableSize.length,
                                            itemBuilder: (context, index) {
                                              if (availableSize[index] == variant.size) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: selectedSizeButton(availableSize[index]),
                                                );
                                              } else {
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Variant tempVariant;
                                                        variantList.forEach((v) {
                                                          if (v.color == variant.color && v.size == availableSize[index]) {
                                                            tempVariant = v;
                                                          }
                                                        });
                                                        if (tempVariant != null) {
                                                          setState(() {
                                                            variant = tempVariant;
                                                          });
                                                        }
                                                      },
                                                      child: sizeButton(availableSize[index])),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          children: [
                                            Text("Select Quantity / Pieces", style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsRegular)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      variant.qty > 0
                                          ? InkWell(
                                              onTap: () async {
                                                print("came here");
                                                int res = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return NumberPickerDialog(minValue: 1, maxValue: variant.qty, initialIntegerValue: buyingQty);
                                                  },
                                                );
                                                if (res != null) {
                                                  setState(() => buyingQty = res);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(3),
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xffD3D3D3),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset: Offset(0, 3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          buyingQty.toString(),
                                                          style: TextStyle(fontSize: 12, fontFamily: PoppinsSemiBold, color: Colors.black),
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Out of Stock",
                                                    style: TextStyle(fontSize: 12, color: Color(0xffF84877), fontFamily: PoppinsRegular),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 20,
                                        color: Color(0xffF9F9F9),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          children: [
                                            Text("Product Description", style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsRegular)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                                      //   child: Text(this.widget.product.details, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Html(
                                          data: this.widget.product.details,
                                          style: {
                                            "div": Style(fontSize: FontSize.small, color: Colors.black, fontFamily: PoppinsRegular),
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 20,
                                        color: Color(0xffF9F9F9),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Text("Rating", style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsRegular)),
                                      //       Text(
                                      //         "Write your review",
                                      //         style: TextStyle(fontSize: 12, color: Color(0xffF84877), fontFamily: PoppinsMedium),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      //   child: userRatingsTile("profilePic", "Samuel I", "good product to buy.", "4"),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      //   child: userRatingsTile("profilePic", "Sammy", "good product to buy.", "3"),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      //   child: userRatingsTile("profilePic", "Sam", "good product to buy.", "2"),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 56),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: variant.imageUrls.map((url) {
                          int index = variant.imageUrls.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      backgroundColor: Color(0xffF84877),
                                    ),
                                    onPressed: () {
                                      Product p = this.widget.product;
                                      p.variant = this.variant;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CheckoutWrapperScreen(checkoutProduct: CheckoutModel(buyingQty: buyingQty, product: p)),
                                          ));
                                    },
                                    child: Text(
                                      "Buy Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    )),
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () async {
                                if (user != null) {
                                  Product p = this.widget.product;
                                  p.variant = this.variant;
                                  bool res = await CartDatabaseService().addProductToCart(user.uid, p);
                                  if (res == null) {
                                    showToast("error occured", Colors.red);
                                  } else if (!res) {
                                    showToast("Already added to cart", Colors.blue);
                                  } else {
                                    showToast("Product added to cart", Colors.green);
                                  }
                                } else {
                                  showToast("please login to continue", Colors.blue);
                                }
                              },
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: Icon(
                                OMIcons.shoppingCart,
                                color: Color(0xffF84877),
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(side: BorderSide(color: Color(0xffF84877))),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget userRatingsTile(String profilePic, String username, String review, String rating) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/login_banner.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(username, style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: PoppinsSemiBold))),
                Row(
                  children: List.generate(int.parse(rating), (index) {
                    return Icon(
                      OMIcons.star,
                      color: Color(0xffEBE300),
                    );
                  }),
                )
              ],
            ),
            Text(review, style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: PoppinsRegular))
          ],
        ))
      ],
    );
  }

  Widget colorButton(String hexColor) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(shape: BoxShape.circle, color: SmartColor.parse(hexColor), border: Border.all(color: Colors.grey, width: 0.5)),
    );
  }

  Widget sizeButton(String size) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey, width: 0.5)),
      child: Center(
        child: Text(
          size,
          style: TextStyle(fontSize: 12, fontFamily: PoppinsSemiBold, color: Colors.black),
        ),
      ),
    );
  }

  Widget selectedSizeButton(String size) {
    return Container(
      padding: EdgeInsets.all(3),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffD3D3D3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
            child: Text(
          size,
          style: TextStyle(fontSize: 12, fontFamily: PoppinsSemiBold, color: Colors.black),
        )),
      ),
    );
  }

  Widget selectedColorButton(String hexColor) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Container(
          decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SmartColor.parse(hexColor),
      )),
    );
  }
}

class NumberPickerDialog extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialIntegerValue;
  NumberPickerDialog({this.initialIntegerValue, this.maxValue, this.minValue});
  @override
  _NumberPickerDialogState createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  int _currentValue;

  @override
  void initState() {
    _currentValue = this.widget.initialIntegerValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberPicker(
          value: this.widget.initialIntegerValue,
          minValue: this.widget.minValue,
          maxValue: this.widget.maxValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context, _currentValue);
            },
            child: Text("Save")),
      ],
    );
  }
}
