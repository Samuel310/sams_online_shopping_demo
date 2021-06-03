import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';
import 'package:obs_admin/screens/common/screen.appbar.dart';
import 'package:obs_admin/screens/products/screen.add.variant.dart';
import 'package:obs_admin/screens/products/screen.manage.variant.dart';
import 'package:obs_admin/services/service.manage.product.dart';
import 'package:obs_admin/services/service.shop.dart';
import 'package:obs_admin/util/common.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:obs_admin/util/progress.screen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class ManageProductScreen extends StatefulWidget {
  final Product product;
  ManageProductScreen({this.product});
  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  bool isLoadingVariant = true;
  bool showSaveBtn = false;
  List<Variant> variantList = [];

  ProgressScreen ps = ProgressScreen();

  // ZefyrController zefyrController;
  // FocusNode focusNode;

  @override
  void initState() {
    categoryController.text = this.widget.product.category;
    subCategoryController.text = this.widget.product.subCategory;
    productNameController.text = this.widget.product.productname;
    productTypeController.text = this.widget.product.producttype;
    descriptionController.text = this.widget.product.description;
    detailsController.text = this.widget.product.details;
    // final document = _loadDocument();
    // focusNode = FocusNode();
    // zefyrController = ZefyrController(document);
    super.initState();
    detailsController.addListener(() {
      if (!showSaveBtn) {
        onTextChanged();
      }
    });
    loadAllVariants();
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  // NotusDocument _loadDocument() {
  //   final converter = NotusHtmlCodec();
  //   Delta delta = converter.decode(this.widget.product.details); // Zefyr compatible Delta
  //   return NotusDocument.fromDelta(delta);
  // }

  void loadAllVariants() async {
    List<Variant> vlist = await ShopDatabaseService().getAllVariants(this.widget.product.productId);
    setState(() {
      variantList = vlist;
      isLoadingVariant = false;
    });
  }

  void onTextChanged() {
    setState(() {
      showSaveBtn = true;
    });
  }

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
                            SizedBox(height: 15),
                            textWidget(controller: categoryController, title: "Category", dissabled: true),
                            SizedBox(height: 15),
                            textWidget(controller: subCategoryController, title: "Sub-Category", dissabled: true),
                            SizedBox(height: 15),
                            textWidget(controller: productNameController, title: "Product Name", onChangeListener: onTextChanged),
                            SizedBox(height: 15),
                            textWidget(controller: productTypeController, title: "Product Type", onChangeListener: onTextChanged),
                            SizedBox(height: 15),
                            textWidget(controller: descriptionController, title: "Description", enableParagraphInput: true, onChangeListener: onTextChanged),
                            SizedBox(height: 15),
                            //textWidget(controller: detailsController, title: "Details", enableParagraphInput: true, onChangeListener: onTextChanged),
                            // ZefyrField(
                            //   height: 300.0, // set the editor's height
                            //   decoration: InputDecoration(labelText: 'Details'),
                            //   controller: detailsController,
                            //   focusNode: focusNode,
                            //   autofocus: false,
                            //   physics: ClampingScrollPhysics(),
                            // ),
                            textWidget(controller: detailsController, title: "Details"),
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
                                              onSaveBtnClicked();
                                            },
                                            child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 15))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            isLoadingVariant
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [SpinKitChasingDots(color: Color(0xffF84877), size: 20.0)],
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: variantList.length,
                                    itemBuilder: (context, index) {
                                      return variantTile(index);
                                    },
                                  ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                appBar(title: "Manage Product", showBackArrow: true, context: context),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, right: 16),
                    child: FloatingActionButton(
                      backgroundColor: Color(0xffF84877),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewVariant(productId: this.widget.product.productId)));
                      },
                      child: Icon(OMIcons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget variantTile(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageVariantScreen(variant: variantList[index])));
          },
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(variantList[index].productImageList.first.url),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\u20B9 ${variantList[index].sellingprice}",
                        style: TextStyle(fontSize: 15, color: Color(0xffF84877)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Size: ${variantList[index].size} | Color: ${variantList[index].colorname}",
                        style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Qty: ${variantList[index].qty}",
                        style: TextStyle(fontSize: 10, color: Color(0xff929292), fontFamily: PoppinsRegular),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSaveBtnClicked() async {
    // Delta _delta = zefyrController.document.toDelta();
    // detailsController.text = NotusHtmlCodec().encode(_delta); // HTML Output
    if (categoryController.text.isNotEmpty &&
        subCategoryController.text.isNotEmpty &&
        productNameController.text.isNotEmpty &&
        productTypeController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        detailsController.text.isNotEmpty) {
      Product product = Product(
        category: categoryController.text,
        description: descriptionController.text,
        details: detailsController.text,
        productname: productNameController.text,
        producttype: productTypeController.text,
        subCategory: subCategoryController.text,
        productId: this.widget.product.productId,
        updatedon: Timestamp.fromDate(DateTime.now()),
      );
      showProgressDialog(context, ps);
      String res = await ManageProductService().updateProduct(product);
      dismissProgressDialog(context, ps);
      if (res != null) {
        showToast(res, Colors.red);
      } else {
        showToast("Successfully Added", Colors.green);
        Navigator.pop(context);
      }
    } else {
      showToast("Fill all fields", Colors.red);
    }
  }
}
