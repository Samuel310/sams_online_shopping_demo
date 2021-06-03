import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/home/local_widgets/banner.widget.dart';
import 'package:oyil_boutique/screens/shop/local_widgets/product_tile.dart';
import 'package:oyil_boutique/screens/shop/screen.product.slider.dart';
import 'package:oyil_boutique/screens/shop/single_product.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<Product> featuredProducts = [];

  //ShopDatabaseService shopDatabaseService = ShopDatabaseService();
  //bool loadingBanners = true;

  @override
  void initState() {
    super.initState();
  }

  // void loadFeaturedProducts() async {
  //   featuredProducts = await shopDatabaseService.getFeaturedProduct();
  //   setState(() {
  //     loadingBanners = false;
  //   });
  // }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Visibility(
                  maintainSize: false,
                  visible: bannersList.isNotEmpty,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                        autoPlay: false,
                        // aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        height: 200,
                        initialPage: 0),
                    itemCount: bannersList.length,
                    itemBuilder: (context, index, realIndex) {
                      return bannerWidget(context, bannersList[index].image, bannersList[index].content, bannersList[index].category, bannersList[index].subcategory);
                    },
                    // itemBuilder: (context, index) {
                    //   return bannerWidget(context, bannersList[index].image, bannersList[index].content, bannersList[index].category, bannersList[index].subcategory);
                    // },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Categories",
                  style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: PoppinsMedium),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                        category: WOMENS_CATEGORY,
                                        subCategory: All_WOMENS_CATEGORY,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 100,
                            // width: MediaQuery.of(context).size.width * 0.5 - 15,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/womens_category.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
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
                                        subCategory: All_KIDS_CATEGORY,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            height: 100,
                            // width: MediaQuery.of(context).size.width * 0.5 - 15,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/kids_category.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("What's new", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: PoppinsMedium)),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 270,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/customise_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Customize Your",
                              style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: PoppinsLight),
                            ),
                            Text(
                              "Outfits In Minutes",
                              style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: PoppinsLight),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
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
                              child: Text(
                                "Contact Us",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: PoppinsMedium,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Featured",
                  style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: PoppinsMedium),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemCount: featuredProducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProductScreen(product: featuredProducts[index])));
                            },
                            child: ProductTile(isFeatured: true, product: featuredProducts[index])),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
