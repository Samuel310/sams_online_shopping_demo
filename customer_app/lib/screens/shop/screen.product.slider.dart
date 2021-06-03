import 'package:flutter/material.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/screens/shop/screen.product.subcategory.dart';
import 'package:oyil_boutique/util/constants.dart';

class ProductScreen extends StatefulWidget {
  final String subCategory;
  final String category;
  ProductScreen({this.subCategory, this.category});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currentIndex;
  PageController controller;

  @override
  void initState() {
    super.initState();
    initView();
  }

  void initView() {
    if (this.widget.category == WOMENS_CATEGORY) {
      if (this.widget.subCategory == All_WOMENS_CATEGORY) {
        currentIndex = 0;
        controller = PageController(initialPage: 0);
      } else if (this.widget.subCategory == INDIAN_WOMENS_CATEGORY) {
        currentIndex = 1;
        controller = PageController(initialPage: 1);
      } else if (this.widget.subCategory == WESTERN_WOMENS_CATEGORY) {
        currentIndex = 2;
        controller = PageController(initialPage: 2);
      } else if (this.widget.subCategory == CONTEMPORARY_WOMENS_CATEGORY) {
        currentIndex = 3;
        controller = PageController(initialPage: 3);
      }
    } else {
      if (this.widget.subCategory == All_KIDS_CATEGORY) {
        currentIndex = 0;
        controller = PageController(initialPage: 0);
      } else if (this.widget.subCategory == BABIES_KIDS_CATEGORY) {
        currentIndex = 1;
        controller = PageController(initialPage: 1);
      } else if (this.widget.subCategory == BOYS_KIDS_CATEGORY) {
        currentIndex = 2;
        controller = PageController(initialPage: 2);
      } else if (this.widget.subCategory == GIRLS_KIDS_CATEGORY) {
        currentIndex = 3;
        controller = PageController(initialPage: 3);
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
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          topTabItem(0, this.widget.category == WOMENS_CATEGORY ? All_WOMENS_CATEGORY : All_KIDS_CATEGORY),
                          topTabItem(1, this.widget.category == WOMENS_CATEGORY ? INDIAN_WOMENS_CATEGORY : BABIES_KIDS_CATEGORY),
                          topTabItem(2, this.widget.category == WOMENS_CATEGORY ? WESTERN_WOMENS_CATEGORY : BOYS_KIDS_CATEGORY),
                          topTabItem(3, this.widget.category == WOMENS_CATEGORY ? CONTEMPORARY_WOMENS_CATEGORY : GIRLS_KIDS_CATEGORY),
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          controller: controller,
                          onPageChanged: (value) {
                            setState(() {
                              currentIndex = value;
                            });
                          },
                          children: <Widget>[
                            ProductSubCategoryScreen(category: this.widget.category),
                            ProductSubCategoryScreen(
                              category: this.widget.category,
                              subCategory: this.widget.category == WOMENS_CATEGORY ? INDIAN_WOMENS_CATEGORY : BABIES_KIDS_CATEGORY,
                            ),
                            ProductSubCategoryScreen(
                              category: this.widget.category,
                              subCategory: this.widget.category == WOMENS_CATEGORY ? WESTERN_WOMENS_CATEGORY : BOYS_KIDS_CATEGORY,
                            ),
                            ProductSubCategoryScreen(
                              category: this.widget.category,
                              subCategory: this.widget.category == WOMENS_CATEGORY ? CONTEMPORARY_WOMENS_CATEGORY : GIRLS_KIDS_CATEGORY,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              appBar(title: this.widget.category, showBackArrow: true, context: context, showSearchIcon: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget topTabItem(int index, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            controller.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.ease);
          });
        },
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: (currentIndex == index) ? Colors.black : Color(0xff7F7F7F), fontFamily: PoppinsRegular, fontSize: 15),
            ),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(shape: BoxShape.circle, color: (currentIndex == index) ? Color(0xffF84877) : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
