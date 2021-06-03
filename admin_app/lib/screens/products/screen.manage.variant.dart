import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obs_admin/models/model.variant.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/services/service.manage.product.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:obs_admin/util/progress.screen.dart';
import 'package:path/path.dart';

class ManageVariantScreen extends StatefulWidget {
  final Variant variant;
  ManageVariantScreen({this.variant});
  @override
  _ManageVariantScreenState createState() => _ManageVariantScreenState();
}

class _ManageVariantScreenState extends State<ManageVariantScreen> {
  TextEditingController colorController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController offController = TextEditingController();
  TextEditingController colorNameController = TextEditingController();

  bool showSaveBtn = false;

  ProgressScreen ps = ProgressScreen();
  ManageProductService mps = ManageProductService();

  @override
  void initState() {
    colorController.text = this.widget.variant.color;
    sizeController.text = this.widget.variant.size;
    priceController.text = this.widget.variant.price.toString();
    sellingPriceController.text = this.widget.variant.sellingprice.toString();
    qtyController.text = this.widget.variant.qty.toString();
    offController.text = this.widget.variant.off.toStringAsFixed(1);
    colorNameController.text = this.widget.variant.colorname;
    super.initState();
  }

  void onTextChanged() {
    setState(() {
      showSaveBtn = true;
    });
  }

  Future onAddImage(BuildContext context, PickedFile pf) async {
    print("came here 1");
    showProgressDialog(context, ps);
    print("came here 2");
    String res = await mps.addImage(this.widget.variant.productId, this.widget.variant.color, File(pf.path));
    dismissProgressDialog(context, ps);
    if (res != null) {
      showToast(res, Colors.red);
    }
    setState(() {
      this.widget.variant.productImageList.add(ProductImages(imageName: basename(File(pf.path).path), url: pf.path));
    });
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
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: false,
                              // aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              height: MediaQuery.of(context).size.height * 0.50,
                              initialPage: 0,
                            ),
                            items: this.widget.variant.productImageList.map((img) {
                              return Builder(
                                builder: (context) {
                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                height: 50,
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () async {
                                                              if (this.widget.variant.productImageList.length > 1) {
                                                                showProgressDialog(context, ps);
                                                                String res = await mps.deleteImage(this.widget.variant.productId, this.widget.variant.color, img.imageName);
                                                                dismissProgressDialog(context, ps);
                                                                if (res != null) {
                                                                  showToast(res, Colors.red);
                                                                }
                                                                setState(() {
                                                                  this.widget.variant.productImageList.remove(img);
                                                                });
                                                              } else {
                                                                showToast("Min. 1 image should exist", Colors.red);
                                                              }
                                                              Navigator.pop(context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text("Remove Image", style: TextStyle(fontFamily: PoppinsRegular, fontSize: 15, color: Color(0xff515C6F))),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      //height: 150,
                                      //width: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: img.url.substring(0, 4) == "http" ? NetworkImage(img.url) : FileImage(File(img.url)),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          backgroundColor: Color(0xffF84877),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Add Image", style: TextStyle(fontFamily: PoppinsSemiBold)),
                                                  content: Container(
                                                    height: 100,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextButton(
                                                                onPressed: () async {
                                                                  try {
                                                                    PickedFile pf = await ImagePicker().getImage(source: ImageSource.gallery);
                                                                    if (pf != null) {
                                                                      await onAddImage(context, pf);
                                                                      Navigator.pop(context);
                                                                    }
                                                                  } catch (e) {
                                                                    print(e);
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text("Choose Image", style: TextStyle(fontFamily: PoppinsRegular, fontSize: 15, color: Color(0xff515C6F))),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextButton(
                                                                onPressed: () async {
                                                                  try {
                                                                    PickedFile pf = await ImagePicker().getImage(source: ImageSource.camera);
                                                                    if (pf != null) {
                                                                      await onAddImage(context, pf);
                                                                      Navigator.pop(context);
                                                                    }
                                                                  } catch (e) {
                                                                    print(e);
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text("Capture Image", style: TextStyle(fontFamily: PoppinsRegular, fontSize: 15, color: Color(0xff515C6F))),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text("Add Image", style: TextStyle(color: Colors.white, fontSize: 15))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          textWidget(controller: qtyController, title: "Quantity / No. of pieces", numberInput: true, onChangeListener: onTextChanged),
                          SizedBox(height: 15),
                          textWidget(controller: sizeController, title: "Size", dissabled: true),
                          SizedBox(height: 15),
                          textWidget(controller: colorController, title: "Color", onChangeListener: onTextChanged, dissabled: true),
                          SizedBox(height: 15),
                          textWidget(controller: colorNameController, title: "Color name", onChangeListener: onTextChanged, dissabled: true),
                          SizedBox(height: 15),
                          textWidget(controller: priceController, title: "Price", onChangeListener: onTextChanged, numberInput: true),
                          SizedBox(height: 15),
                          textWidget(
                              controller: offController,
                              title: "Off %",
                              onChangeListener: () {
                                sellingPriceController.text = ((((100 - int.parse(offController.text)) * int.parse(priceController.text)) / 100).round()).toStringAsFixed(2);
                                setState(() {
                                  showSaveBtn = true;
                                });
                              },
                              numberInput: true),
                          SizedBox(height: 15),
                          textWidget(controller: sellingPriceController, title: "Selling price", onChangeListener: onTextChanged, dissabled: true),
                          Visibility(
                            visible: showSaveBtn,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            backgroundColor: Color(0xffF84877),
                                          ),
                                          onPressed: () {
                                            onSaveBtnClicked(context);
                                          },
                                          child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 15))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              appBar(title: "Manage Product", showBackArrow: true, context: context),
            ],
          ),
        ),
      ),
    );
  }

  void onSaveBtnClicked(BuildContext context) async {
    if (colorController.text.isNotEmpty &&
        sizeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        sellingPriceController.text.isNotEmpty &&
        qtyController.text.isNotEmpty &&
        offController.text.isNotEmpty &&
        colorNameController.text.isNotEmpty) {
      Variant variant = Variant(
        color: colorController.text,
        colorname: colorNameController.text,
        off: double.parse(offController.text),
        price: int.parse(priceController.text),
        qty: int.parse(qtyController.text),
        sellingprice: int.parse(sellingPriceController.text),
        size: sizeController.text,
        productId: this.widget.variant.productId,
        productImageList: this.widget.variant.productImageList,
        variantId: this.widget.variant.variantId,
        updatedon: Timestamp.fromDate(DateTime.now()),
      );
      showProgressDialog(context, ps);
      String res = await mps.updateVariant(this.widget.variant.productId, variant);
      dismissProgressDialog(context, ps);
      if (res != null) {
        showToast(res, Colors.red);
      } else {
        showToast("Successfully Added", Colors.green);
        Navigator.pop(context);
      }
    } else {
      showToast("Unable to add product", Colors.red);
    }
  }
}
