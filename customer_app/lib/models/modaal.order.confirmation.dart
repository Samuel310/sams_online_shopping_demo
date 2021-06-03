import 'package:oyil_boutique/models/modals.orders.dart';

class OrderConfirmationModel {
  Orders order;
  int previousAvailableQty;
  OrderConfirmationModel({this.order, this.previousAvailableQty});
}
