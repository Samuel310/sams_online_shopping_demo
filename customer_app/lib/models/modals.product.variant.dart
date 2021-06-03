class Variant {
  Variant(
      {this.variantId,
      this.productId,
      this.color,
      this.size,
      this.price,
      this.sellingprice,
      this.qty,
      this.off,
      this.imageUrls,
      this.colorname});

  String variantId;
  String productId;
  String color;
  String size;
  int price;
  int sellingprice;
  int qty;
  double off;
  List<String> imageUrls;
  String colorname;
}
