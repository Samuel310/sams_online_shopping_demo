import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';

class Order {
  String orderId;
  String ahEmail;
  String orderStatus;
  bool paid;
  Timestamp placedDate;
  Product productData;
  int qty;
  int totalPrice;
  String userId;
  Variant variantData;
  String address;
  String city;
  String country;
  String fullname;
  String phone;
  String pincode;
  String state;

  Order({
    this.ahEmail,
    this.orderStatus,
    this.paid,
    this.placedDate,
    this.productData,
    this.qty,
    this.totalPrice,
    this.userId,
    this.variantData,
    this.orderId,
    this.address,
    this.city,
    this.country,
    this.fullname,
    this.phone,
    this.pincode,
    this.state,
  });
}
