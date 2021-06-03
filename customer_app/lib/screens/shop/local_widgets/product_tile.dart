import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/services/service.wishlist.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  final bool isFeatured;
  ProductTile({this.product, this.isFeatured = false});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  WishlistDatabaseService wishlistDatabaseService = WishlistDatabaseService();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    bool isLiked = false;
    int wishlistIndex;
    String wishlistid;
    globalWishList.forEach((element) {
      if (element.product.productId == widget.product.productId) {
        isLiked = true;
        wishlistid = element.wishlistid;
        wishlistIndex = globalWishList.indexOf(element);
      }
    });
    return Container(
      width: this.widget.isFeatured ? 120 : null,
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.product.variant.imageUrls[0]),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isLiked ? OMIcons.favorite : OMIcons.favoriteBorder,
                    color: isLiked ? Color(0xffF84877) : Colors.white,
                  ),
                  onPressed: () async {
                    if (user != null) {
                      if (isLiked) {
                        await wishlistDatabaseService.removeProductFromWishlist(user.uid, wishlistid, wishlistIndex);
                        setState(() {});
                      } else {
                        Product p = this.widget.product;
                        await wishlistDatabaseService.addProductToWishlist(user.uid, p);
                        setState(() {});
                      }
                    } else {
                      showToast("Please login to continue", Colors.blue);
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF84877),
                      ),
                      child: Text("${double.parse((widget.product.variant.off).toStringAsFixed(2))}% OFF", style: TextStyle(fontSize: 10, fontFamily: PoppinsLight, color: Colors.white))),
                ),
              )
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      widget.product.productname,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: PoppinsMedium),
                    ),
                  ),
                ),
                Text(
                  "\u20B9 ${widget.product.variant.sellingprice}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff515C6F),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    widget.product.producttype,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Color(0xff929292), fontFamily: PoppinsMedium),
                  ),
                )),
                Text(
                  "\u20B9 ${widget.product.variant.price}",
                  style: TextStyle(fontSize: 10, color: Color(0xff929292), decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
