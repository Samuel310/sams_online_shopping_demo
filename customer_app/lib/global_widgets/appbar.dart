import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/screens/shop/screen.search.dart';
import 'package:oyil_boutique/screens/wishlist/screen.wishlist.wrapper.dart';
import 'package:oyil_boutique/util/constants.dart';

Widget appBar({String title, bool showBackArrow = false, BuildContext context, bool showSearchIcon = false, bool showWishlistIcon = true}) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Visibility(
            visible: showBackArrow,
            child: SizedBox(
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
          ),
          //Image(image: AssetImage('assets/images/logo.png'), height: 45),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16, child: Text("Sam's", style: TextStyle(fontFamily: PoppinsBold, color: Color(0xffF84877)))),
              SizedBox(height: 16, child: Text("Store", style: TextStyle(fontFamily: PoppinsBold, color: Color(0xffF84877)))),
            ],
          ),
          Expanded(
              child: Text(
            title,
            style: TextStyle(fontSize: 14, fontFamily: PoppinsMedium, color: Color(0xff515C6F)),
            textAlign: TextAlign.center,
          )),
          showSearchIcon
              ? SizedBox(
                  width: 50,
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                    child: Icon(
                      OMIcons.search,
                      color: Color(0xff515C6F),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ));
                    },
                  ),
                )
              : Visibility(visible: showBackArrow == true, child: SizedBox(width: 50)),
          showWishlistIcon
              ? SizedBox(
                  width: 50,
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                    child: Icon(
                      OMIcons.favoriteBorder,
                      color: Color(0xff515C6F),
                    ),
                    onPressed: () {
                      if (title != "Wishlist") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WishListWrapper(),
                            ));
                      }
                    },
                  ),
                )
              : Visibility(
                  visible: showSearchIcon == false,
                  child: SizedBox(width: 50),
                ),
        ],
      ),
    ),
  );
}
