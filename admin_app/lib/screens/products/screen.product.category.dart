import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/products/screen.product.slider.dart';
import 'package:obs_admin/util/constants.dart';

class ProductCategoryScreen extends StatefulWidget {
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  ExpandableController womensController = ExpandableController();
  ExpandableController kidsController = ExpandableController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    womensController.addListener(() {
      if (kidsController.expanded && womensController.expanded) {
        kidsController.toggle();
      }
    });
    kidsController.addListener(() {
      if (womensController.expanded && kidsController.expanded) {
        womensController.toggle();
      }
    });
  }

  @override
  void dispose() {
    womensController.dispose();
    kidsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 56, bottom: 65),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 160,
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(image: AssetImage('assets/images/cs_customise.png'), fit: BoxFit.fill),
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          womensCategory(context),
                          SizedBox(height: 10),
                          kidsCategory(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              appBar(title: "Products Category", context: context, showBackArrow: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget womensCategory(BuildContext context) {
    return ExpandableNotifier(
      controller: womensController,
      child: Column(
        children: [
          Expandable(
            collapsed: ExpandableButton(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/cs_womens.png'), fit: BoxFit.fill),
                ),
              ),
            ),
            expanded: Column(
              children: [
                InkWell(
                  onTap: () {
                    womensController.toggle();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/cs_womens.png'), fit: BoxFit.fill),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: WOMENS_CATEGORY, subCategory: INDIAN_WOMENS_CATEGORY)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/images/indian_bg.png'), fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: WOMENS_CATEGORY, subCategory: WESTERN_WOMENS_CATEGORY)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/images/western_bg.png'), fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: WOMENS_CATEGORY, subCategory: CONTEMPORARY_WOMENS_CATEGORY)));
                        },
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/contemporary_bg.png'), fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget kidsCategory(BuildContext context) {
    return ExpandableNotifier(
      controller: kidsController,
      child: Column(
        children: [
          Expandable(
            collapsed: ExpandableButton(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/cs_kids.png'), fit: BoxFit.fill),
                ),
              ),
            ),
            expanded: Column(
              children: [
                InkWell(
                  onTap: () {
                    kidsController.toggle();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/cs_kids.png'), fit: BoxFit.fill),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: KIDS_CATEGORY, subCategory: BOYS_KIDS_CATEGORY)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/images/boys_bg.png'), fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: KIDS_CATEGORY, subCategory: BABIES_KIDS_CATEGORY)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/images/babies_bg.png'), fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: KIDS_CATEGORY, subCategory: GIRLS_KIDS_CATEGORY)));
                        },
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/girls_bg.png'), fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
