import 'package:cloud_firestore/cloud_firestore.dart';

class Variant {
  Variant({
    this.variantId,
    this.productId,
    this.color,
    this.size,
    this.price,
    this.sellingprice,
    this.qty,
    this.off,
    this.productImageList,
    this.colorname,
    this.createdon,
    this.updatedon,
  });

  String variantId;
  String productId;
  String color;
  String size;
  int price;
  int sellingprice;
  int qty;
  double off;
  List<ProductImages> productImageList;
  String colorname;
  Timestamp createdon, updatedon;
}

class ProductImages {
  String url, imageName;
  ProductImages({this.imageName, this.url});
}
