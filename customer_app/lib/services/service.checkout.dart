import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oyil_boutique/models/modals.orders.dart';
import 'package:oyil_boutique/models/models.address.dart';

class CheckOutDatabaseService {
  CollectionReference userCollection;
  CollectionReference ordersCollection;

  CheckOutDatabaseService() {
    userCollection = FirebaseFirestore.instance.collection("users");
    ordersCollection = FirebaseFirestore.instance.collection("orders");
  }

  Future<List<ShippingAddress>> getAllAddress(String userID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> qs = await userCollection.doc(userID).collection('address').get();
      return await Future.wait(qs.docs.map((doc) async {
        return ShippingAddress(
          id: doc.id ?? 'EMPTY',
          address: doc.data()['address'] ?? 'EMPTY',
          city: doc.data()['city'] ?? 'EMPTY',
          country: doc.data()['country'] ?? 'EMPTY',
          fullname: doc.data()['fullname'] ?? 'EMPTY',
          phone: doc.data()['phone'] ?? 'EMPTY',
          pincode: doc.data()['pincode'] ?? 'EMPTY',
          state: doc.data()['state'] ?? 'EMPTY',
        );
      }).toList());
    } catch (e) {
      print("XXXXXXXXXX error on get all address");
      print(e);
      return null;
    }
  }

  Future addNewAddress(String userID, ShippingAddress address) async {
    try {
      Map<String, dynamic> addressData = {
        'fullname': address.fullname,
        'phone': address.phone,
        'address': address.address,
        'city': address.city,
        'state': address.state,
        'country': address.country,
        'pincode': address.pincode
      };
      await userCollection.doc(userID).collection('address').doc().set(addressData);
    } catch (e) {
      print("XXXXXXXXXX error on addNewAddress");
      print(e);
      return e.message;
    }
  }

  Future deleteAddress(String userID, String addressid) async {
    try {
      await userCollection.doc(userID).collection('address').doc(addressid).delete().catchError((e) {
        print("XXXXXXXXXX error on deleteAddress 1");
        print(e);
      });
    } catch (e) {
      print("XXXXXXXXXX error on deleteAddress 2");
      print(e);
    }
  }

  Future<Map<String, dynamic>> getAddressWithId(String userID, ShippingAddress address) async {
    try {
      QuerySnapshot<Map<String, dynamic>> qSnapshot = await userCollection
          .doc(userID)
          .collection('address')
          .where('address', isEqualTo: address.address)
          .where('city', isEqualTo: address.city)
          .where('country', isEqualTo: address.country)
          .where('fullname', isEqualTo: address.fullname)
          .where('phone', isEqualTo: address.phone)
          .where('pincode', isEqualTo: address.pincode)
          .where('state', isEqualTo: address.state)
          .get();
      int totalDocs = qSnapshot.docs.length;
      QueryDocumentSnapshot<Map<String, dynamic>> doc = qSnapshot.docs.first;
      ShippingAddress add = ShippingAddress(
        id: doc.id ?? 'EMPTY',
        address: doc.data()['address'] ?? 'EMPTY',
        city: doc.data()['city'] ?? 'EMPTY',
        country: doc.data()['country'] ?? 'EMPTY',
        fullname: doc.data()['fullname'] ?? 'EMPTY',
        phone: doc.data()['phone'] ?? 'EMPTY',
        pincode: doc.data()['pincode'] ?? 'EMPTY',
        state: doc.data()['state'] ?? 'EMPTY',
      );
      return {'totalDocs': totalDocs, 'address': totalDocs != 0 ? add : null};
    } catch (e) {
      print("XXXXXXXXXX error on getAddressWithId");
      print(e.message);
      if (e.message == 'No element') {
        return {'totalDocs': 0, 'address': null};
      }
      return null;
    }
  }

  Future<Orders> placeOrder(Orders order) async {
    try {
      Map<String, dynamic> orderData = {
        'productId': order.productId,
        'variantId': order.variantId,
        'userId': order.userId,
        // 'addressId': order.addressId,
        'address': order.address.address,
        'city': order.address.city,
        'country': order.address.country,
        'fullname': order.address.fullname,
        'phone': order.address.phone,
        'pincode': order.address.pincode,
        'state': order.address.state,
        'qty': order.qty,
        'totalPrice': order.totalPrice,
        'placedDate': order.placedDate,
        'orderStatus': order.orderStatus,
        'paid': order.paid,
        'ahEmail': order.ahEmail,
      };
      await ordersCollection.add(orderData);
      QuerySnapshot qSnapshot = await ordersCollection
          .where('productId', isEqualTo: order.productId)
          .where('variantId', isEqualTo: order.variantId)
          .where('userId', isEqualTo: order.userId)
          //.where('addressId', isEqualTo: order.addressId)
          .where('qty', isEqualTo: order.qty)
          .where('totalPrice', isEqualTo: order.totalPrice)
          .where('placedDate', isEqualTo: order.placedDate)
          .where('orderStatus', isEqualTo: order.orderStatus)
          .where('paid', isEqualTo: order.paid)
          .where('ahEmail', isEqualTo: order.ahEmail)
          .get();
      int totalDocs = qSnapshot.docs.length;
      if (totalDocs == 1) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc = qSnapshot.docs.first;
        Orders updatedOrder = Orders(
          //addressId: doc.data()['addressId'] ?? 'EMPTY',
          address: order.address,
          orderStatus: doc.data()['orderStatus'] ?? 'EMPTY',
          paid: doc.data()['paid'] ?? 'EMPTY',
          placedDate: doc.data()['placedDate'] ?? 'EMPTY',
          productId: doc.data()['productId'] ?? 'EMPTY',
          qty: doc.data()['qty'] ?? 'EMPTY',
          totalPrice: doc.data()['totalPrice'] ?? 'EMPTY',
          userId: doc.data()['userId'] ?? 'EMPTY',
          variantId: doc.data()['variantId'] ?? 'EMPTY',
          orderId: doc.id ?? 'EMPTY',
          ahEmail: doc.data()['ahEmail'] ?? 'EMPTY',
        );
        return updatedOrder;
      } else {
        return null;
      }
    } catch (e) {
      print("XXXXXXXXXX error on placeOrder");
      print(e);
      return null;
    }
  }

  Future<bool> finalizeOrder(String orderId) async {
    try {
      await ordersCollection.doc(orderId).update({'paid': true});
      return true;
    } catch (e) {
      print("XXXXXXXXXX error on finalizeOrder");
      print(e);
      return false;
    }
  }
}
