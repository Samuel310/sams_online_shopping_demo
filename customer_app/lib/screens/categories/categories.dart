import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/shop/screen.product.slider.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/util/common.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Contact Us"),
                      content: Text("Have a perfect design in your mind, Feel free to contact us and place your order."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("Cancel", style: TextStyle(color: Color(0xffF84877))),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            if (adminContactDetail != null) {
                              launchWhatsApp(message: "", phone: adminContactDetail.phone);
                            } else {
                              showToast("Unable to contact at the moment", Colors.red);
                            }
                          },
                          child: Text("Ok", style: TextStyle(color: Color(0xffF84877))),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/cs_customise.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              womensCategory(context),
              SizedBox(
                height: 10,
              ),
              kidsCategory(context),
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
              // <-- Expands when tapped on the cover photo
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cs_womens.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            expanded: Column(children: [
              InkWell(
                onTap: () {
                  womensController.toggle();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/cs_womens.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                                category: WOMENS_CATEGORY,
                                                subCategory: INDIAN_WOMENS_CATEGORY,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/indian_bg.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                                category: WOMENS_CATEGORY,
                                                subCategory: WESTERN_WOMENS_CATEGORY,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/western_bg.png'),
                                      fit: BoxFit.fill,
                                    ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                      category: WOMENS_CATEGORY,
                                      subCategory: CONTEMPORARY_WOMENS_CATEGORY,
                                    )));
                      },
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/contemporary_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
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
              // <-- Expands when tapped on the cover photo
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cs_kids.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            expanded: Column(children: [
              InkWell(
                onTap: () {
                  kidsController.toggle();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/cs_kids.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                                category: KIDS_CATEGORY,
                                                subCategory: BOYS_KIDS_CATEGORY,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/boys_bg.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                                category: KIDS_CATEGORY,
                                                subCategory: BABIES_KIDS_CATEGORY,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/babies_bg.png'),
                                      fit: BoxFit.fill,
                                    ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                      category: KIDS_CATEGORY,
                                      subCategory: GIRLS_KIDS_CATEGORY,
                                    )));
                      },
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/girls_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
