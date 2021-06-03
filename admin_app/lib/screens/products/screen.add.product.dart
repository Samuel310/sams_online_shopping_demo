import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obs_admin/models/model.colors.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/products/alert.colors.menu.dart';
import 'package:obs_admin/services/service.manage.product.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:obs_admin/util/progress.screen.dart';

class AddNewProduct extends StatefulWidget {
  final String category, subcategory;
  AddNewProduct({this.category, this.subcategory});
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  TextEditingController colorController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController offController = TextEditingController();
  TextEditingController colorNameController = TextEditingController();

  List<File> imageFileList = [];

  ProgressScreen ps = ProgressScreen();

  //ZefyrController zefyrController;
  //FocusNode focusNode;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    //final document = _loadDocument();
    //focusNode = FocusNode();
    //zefyrController = ZefyrController(document);

    categoryController.text = this.widget.category;
    subCategoryController.text = this.widget.subcategory;
    super.initState();
  }

  // NotusDocument _loadDocument() {
  //   final Delta delta = Delta()..insert("Some info\n");
  //   return NotusDocument.fromDelta(delta);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF84877),
      body: Scaffold(
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
                            Visibility(
                              visible: imageFileList.isNotEmpty,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: false,
                                  enlargeCenterPage: true,
                                  height: MediaQuery.of(context).size.height * 0.50,
                                  initialPage: 0,
                                ),
                                items: imageFileList.map((url) {
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
                                                                onPressed: () {
                                                                  setState(() {
                                                                    imageFileList.remove(url);
                                                                  });
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
                                          decoration: BoxDecoration(image: DecorationImage(image: FileImage(url), fit: BoxFit.fill)),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
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
                                                                    Navigator.pop(context);
                                                                    try {
                                                                      PickedFile pf = await ImagePicker().getImage(source: ImageSource.gallery);
                                                                      if (pf != null) {
                                                                        setState(() {
                                                                          imageFileList.add(File(pf.path));
                                                                        });
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
                                                                    Navigator.pop(context);
                                                                    try {
                                                                      PickedFile pf = await ImagePicker().getImage(source: ImageSource.camera);
                                                                      if (pf != null) {
                                                                        setState(() {
                                                                          imageFileList.add(File(pf.path));
                                                                        });
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
                            textWidget(controller: categoryController, title: "Category", dissabled: true),
                            SizedBox(height: 15),
                            textWidget(controller: subCategoryController, title: "Sub-Category", dissabled: true),
                            SizedBox(height: 15),
                            textWidget(controller: productNameController, title: "Product Name"),
                            SizedBox(height: 15),
                            textWidget(controller: productTypeController, title: "Product Type"),
                            SizedBox(height: 15),
                            textWidget(controller: descriptionController, title: "Description", enableParagraphInput: true),
                            // SizedBox(height: 15),
                            // textWidget(controller: detailsController, title: "Details", enableParagraphInput: true),

                            SizedBox(height: 15),
                            textWidget(controller: qtyController, title: "Quantity / No. of pieces", numberInput: true),
                            SizedBox(height: 15),
                            textWidget(controller: sizeController, title: "Size"),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                chooseColorBtn();
                              },
                              child: textWidget(controller: colorController, title: "Color", dissabled: true),
                            ),
                            SizedBox(height: 15),
                            textWidget(controller: colorNameController, title: "Color name"),
                            SizedBox(height: 15),
                            textWidget(controller: priceController, title: "Price", numberInput: true),
                            SizedBox(height: 15),
                            textWidget(
                              controller: offController,
                              title: "Off %",
                              numberInput: true,
                              onChangeListener: () {
                                sellingPriceController.text = ((((100 - int.parse(offController.text)) * int.parse(priceController.text)) / 100).round()).toString();
                              },
                            ),
                            SizedBox(height: 15),
                            textWidget(controller: sellingPriceController, title: "Selling price", dissabled: true),
                            SizedBox(height: 15),
                            // ZefyrField(
                            //   height: 300.0, // set the editor's height
                            //   decoration: InputDecoration(labelText: 'Details'),
                            //   controller: zefyrController,
                            //   focusNode: focusNode,
                            //   autofocus: false,
                            //   physics: ClampingScrollPhysics(),
                            // ),
                            textWidget(controller: detailsController, title: "Datails"),
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
                                            onSaveBtnClicked();
                                          },
                                          child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 15))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                appBar(title: "Add Product", showBackArrow: true, context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chooseColorBtn() async {
    // showDialog(
    //   context: context,
    //   child: AlertDialog(
    //     title: const Text('Pick a color!'),
    //     content: SingleChildScrollView(
    //       child: ColorPicker(
    //         pickerColor: pickerColor,
    //         onColorChanged: changeColor,
    //         showLabel: true,
    //         pickerAreaHeightPercent: 0.8,
    //       ),
    //     ),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: const Text('Got it'),
    //         onPressed: () async {
    //           String colorname = await getColorName("#" + pickerColor.value.toRadixString(16).substring(2));
    //           setState(() {
    //             colorController.text = "#" + pickerColor.value.toRadixString(16).substring(2);
    //             colorNameController.text = colorname;
    //           });
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //     ],
    //   ),
    // );
    OBSColor obsColor = await showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return ColorsMenuAlert();
      },
    );
    if (obsColor != null) {
      setState(() {
        colorController.text = obsColor.color;
        colorNameController.text = obsColor.colorName;
      });
    }
  }

  void onSaveBtnClicked() async {
    // Delta _delta = zefyrController.document.toDelta();
    // detailsController.text = NotusHtmlCodec().encode(_delta); // HTML Output
    if (categoryController.text.isNotEmpty &&
        subCategoryController.text.isNotEmpty &&
        productNameController.text.isNotEmpty &&
        productTypeController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        detailsController.text.isNotEmpty &&
        detailsController.text.length > 10 &&
        colorController.text.isNotEmpty &&
        sizeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        sellingPriceController.text.isNotEmpty &&
        qtyController.text.isNotEmpty &&
        offController.text.isNotEmpty &&
        colorNameController.text.isNotEmpty &&
        imageFileList.isNotEmpty) {
      Product product = Product(
        category: categoryController.text,
        description: descriptionController.text,
        details: detailsController.text,
        productname: productNameController.text,
        producttype: productTypeController.text,
        subCategory: subCategoryController.text,
        createdon: Timestamp.fromDate(DateTime.now()),
        updatedon: Timestamp.fromDate(DateTime.now()),
      );
      Variant variant = Variant(
        color: colorController.text,
        colorname: colorNameController.text,
        off: double.parse(offController.text),
        price: int.parse(priceController.text),
        qty: int.parse(qtyController.text),
        sellingprice: int.parse(sellingPriceController.text),
        size: sizeController.text,
        createdon: Timestamp.fromDate(DateTime.now()),
        updatedon: Timestamp.fromDate(DateTime.now()),
      );
      showProgressDialog(context, ps);
      String res = await ManageProductService().addNewProduct(product, variant, imageFileList);
      dismissProgressDialog(context, ps);
      if (res != null) {
        showToast(res, Colors.red);
      } else {
        showToast("Successfully Added", Colors.green);
        Navigator.pop(context);
      }
    } else {
      showToast("Unable to add product, fill all fields", Colors.red);
    }
  }
}
