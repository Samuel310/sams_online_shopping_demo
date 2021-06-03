import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productId, category, description, details, productname, producttype, subCategory;
  Timestamp createdon, updatedon;
  Product({
    this.category,
    this.description,
    this.details,
    this.productId,
    this.productname,
    this.producttype,
    this.subCategory,
    this.createdon,
    this.updatedon,
  });
}
