import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oyil_boutique/models/models.address.dart';

class Orders {
  String orderId, productId, variantId, userId;
  ShippingAddress address;
  int qty, totalPrice;
  Timestamp placedDate;
  String orderStatus;
  bool paid;
  String ahEmail;

  Orders({
    this.address,
    this.orderId,
    this.orderStatus,
    this.paid,
    this.placedDate,
    this.productId,
    this.qty,
    this.totalPrice,
    this.userId,
    this.variantId,
    this.ahEmail,
  });
}
