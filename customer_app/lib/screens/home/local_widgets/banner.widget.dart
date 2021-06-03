import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/shop/screen.product.slider.dart';
import 'package:oyil_boutique/util/constants.dart';

Widget bannerWidget(BuildContext context, String imageLocation, String content, String category, String subcategory) {
  double w = MediaQuery.of(context).size.width;
  return Container(
    width: w,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageLocation),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 100, bottom: 10),
                child: Text(content,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: PoppinsLight,
                      color: Colors.white,
                    )),
              ),
              OutlinedButton(
                //borderSide: BorderSide(color: Colors.white, width: 0.5),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductScreen(
                                category: category,
                                subCategory: subcategory,
                              )));
                },
                child: Text(
                  "Shop now",
                  style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium, fontSize: 12),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
