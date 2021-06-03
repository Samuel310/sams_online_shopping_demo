import 'package:flutter/material.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/products/screen.add.product.dart';
import 'package:obs_admin/screens/products/screen.product.subcategory.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

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
  String currentSubCategory;

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

    if (this.widget.subCategory == All_WOMENS_CATEGORY || this.widget.subCategory == All_KIDS_CATEGORY) {
      currentSubCategory = null;
    } else {
      currentSubCategory = this.widget.subCategory;
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
                              if (value == 0) {
                                currentSubCategory = null;
                              } else if (value == 1) {
                                currentSubCategory = this.widget.category == WOMENS_CATEGORY ? INDIAN_WOMENS_CATEGORY : BABIES_KIDS_CATEGORY;
                              } else if (value == 2) {
                                currentSubCategory = this.widget.category == WOMENS_CATEGORY ? WESTERN_WOMENS_CATEGORY : BOYS_KIDS_CATEGORY;
                              } else if (value == 3) {
                                currentSubCategory = this.widget.category == WOMENS_CATEGORY ? CONTEMPORARY_WOMENS_CATEGORY : GIRLS_KIDS_CATEGORY;
                              }
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
              Visibility(
                visible: currentSubCategory != null,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, right: 16),
                    child: FloatingActionButton(
                      backgroundColor: Color(0xffF84877),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewProduct(
                              category: this.widget.category,
                              subcategory: currentSubCategory,
                            ),
                          ),
                        );
                      },
                      child: Icon(OMIcons.add, color: Colors.white),
                    ),
                  ),
                ),
              ),
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
            // if (index == 0) {
            //   currentSubCategory = null;
            // } else if (index == 1) {
            //   currentSubCategory = this.widget.category == WOMENS_CATEGORY ? INDIAN_WOMENS_CATEGORY : BABIES_KIDS_CATEGORY;
            // } else if (index == 2) {
            //   currentSubCategory = this.widget.category == WOMENS_CATEGORY ? WESTERN_WOMENS_CATEGORY : BOYS_KIDS_CATEGORY;
            // } else if (index == 3) {
            //   currentSubCategory = this.widget.category == WOMENS_CATEGORY ? CONTEMPORARY_WOMENS_CATEGORY : GIRLS_KIDS_CATEGORY;
            // }
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
