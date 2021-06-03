import 'package:oyil_boutique/models/modals.product.variant.dart';

class Product {
  Product(
      {this.productId,
      this.category,
      this.subCategory,
      this.productname,
      this.producttype,
      this.description,
      this.details,
      this.variant});

  String productId;
  String category;
  String subCategory;
  String productname;
  String producttype;
  String description;
  String details;
  Variant variant;
}
