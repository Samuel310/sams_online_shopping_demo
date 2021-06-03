import 'package:obs_admin/models/model.product.dart';

class LikedProduct {
  Product product;
  String variantid;
  int likes;
  LikedProduct({this.likes, this.product, this.variantid});
}
